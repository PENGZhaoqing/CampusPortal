class Resource < ActiveRecord::Base
  has_many :accesses, dependent: :destroy
  belongs_to :user

end
