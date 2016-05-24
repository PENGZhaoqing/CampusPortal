class CreateRelationships < ActiveRecord::Migration
  def change
    # create_table :users_oauth_applications, id: false do |t|
    #   t.belongs_to :user
    #   t.belongs_to :oauth_application
    #   t.timestamps
    # end
    #
    # add_index :users_oauth_applications, :user_id
    # add_index :users_oauth_applications, :oauth_application_id
    #
    # create_table :cooperators_oauth_applications, id: false do |t|
    #   t.belongs_to :cooperator
    #   t.belongs_to :oauth_application
    #   t.timestamps
    # end
    #
    # add_index :cooperators_oauth_applications, [:cooperator_id]
    # add_index :cooperators_oauth_applications, [:oauth_application_id]


    create_table :relationships do |t|
      t.belongs_to :user
      t.belongs_to :application
      t.timestamps
    end
    add_index :relationships, [:user_id,:application_id]

  end
end
