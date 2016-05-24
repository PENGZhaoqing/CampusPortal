class Relationship < ActiveRecord::Base

  belongs_to :user
  belongs_to :application, class_name:  'Doorkeeper::Application'

  validates :user_id, presence: true
  validates :application_id, presence: true

end
