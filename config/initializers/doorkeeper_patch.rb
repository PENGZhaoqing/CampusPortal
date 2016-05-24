# config/initializers/doorkeeper_patch.rb
# Log the Doorkeeper extension
Rails.logger.info "Extending Doorkeeper from config/initializer/doorkeeper_patch.rb"

Doorkeeper::Application.class_eval do

  # has_and_belongs_to_many :users
  # has_and_belongs_to_many :cooperators
  mount_uploader :picture, PictureUploader
  has_many :relationships, foreign_key: 'application_id', dependent: :destroy
  has_many :users, through: :relationships, source: :user

  has_paper_trail
  belongs_to :cooperator
  validate :picture_size

  def self.filter_by_type(type)
    where("user_oriented = :type", type: type)
  end

  private
  def picture_size
    if picture.size > 2.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end

  # keep adding any other methods, validations, relations here...
end