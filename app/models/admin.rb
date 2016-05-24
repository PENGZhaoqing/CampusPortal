class Admin < ActiveRecord::Base

  attr_accessor :remember_token
  validates :name, presence: true, length: {maximum: 50}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: true}

  #1. The ability to save a securely hashed password_digest attribute to the database
  #2. A pair of virtual attributes (password and password_confirmation), including presence validations upon object creation and a validation requiring that they match
  #3. An authenticate method that returns the user when the password is correct (and false otherwise)
  has_secure_password
  # has_secure_password automatically adds an authenticate method to the corresponding model objects.
  # This method determines if a given password is valid for a particular user by computing its digest and comparing the result to password_digest in the database.

  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

  # Returns the hash digest of the given string.
  def Admin.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def Admin.new_token
    SecureRandom.urlsafe_base64
  end

  def admin_remember
    self.remember_token = Admin.new_token
    update_attribute(:remember_digest, Admin.digest(remember_token))
  end

  def admin_forget
    update_attribute(:remember_digest, nil)
  end

  # Returns true if the given token matches the digest.
  def admin_authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

end
