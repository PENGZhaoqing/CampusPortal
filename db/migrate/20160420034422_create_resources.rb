class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.belongs_to :user
      t.string :name
      t.timestamps null: false
    end
    add_index :resources,:user_id
  end
end
