class AddPictureToOauthApplications < ActiveRecord::Migration
  def change
    add_column :oauth_applications, :picture, :string
    add_column :cooperators ,:icon,:string
    add_column :users ,:icon,:string
  end
end
