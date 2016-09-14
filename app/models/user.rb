class User < ActiveRecord::Base

  has_many :relationships, foreign_key: 'user_id', dependent: :destroy
  has_many :applications, class_name: 'Doorkeeper::Application', through: :relationships, source: :application

  has_many :oauth_applications, class_name: 'Doorkeeper::Application', dependent: :destroy, foreign_key: :developer_id

  has_many :accesses, dependent: :destroy
  mount_uploader :icon, IconUploader

  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest

  validates :name, presence: true, length: {maximum: 50}
  validate :icon_size

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}

  #1. The ability to save a securely hashed password_digest attribute to the database
  #2. A pair of virtual attributes (password and password_confirmation), including presence validations upon object creation and a validation requiring that they match
  #3. An authenticate method that returns the user when the password is correct (and false otherwise)
  has_secure_password
  # has_secure_password automatically adds an authenticate method to the corresponding model objects.
  # This method determines if a given password is valid for a particular user by computing its digest and comparing the result to password_digest in the database.
  has_paper_trail

  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

  def User.filter_by_type(type)
    User.where("role = :type", type: type)
  end

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def self.filter_by_users
    User.where(:developer => false).where(:admin => false)
  end

  private

  def icon_size
    if icon.size > 2.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end

  def downcase_email
    self.email = email.downcase
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
