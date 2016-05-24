class AddOwnerToApplication < ActiveRecord::Migration
  def change
    # add_column :oauth_applications, :owner_id, :integer, null: true
    # add_column :oauth_applications, :owner_type, :string, null: true
    # add_index :oauth_applications, [:owner_id, :owner_type]

    add_column :oauth_applications, :homepage, :string, null: true
    add_column :oauth_applications, :user_oriented, :string, null: true
    add_column :oauth_applications, :description, :string, null: true
    add_column :oauth_applications, :cooperator_id,:integer
    add_index :oauth_applications, :cooperator_id

  end
end