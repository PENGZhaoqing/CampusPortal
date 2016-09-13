class CreateAccesses < ActiveRecord::Migration
  def change
    create_table :accesses do |t|
      t.text   :node
      t.text   :path
      t.integer   :app_id
      t.belongs_to :user
      t.timestamps null: false
    end

    add_index :accesses,:user_id
    add_index :accesses,:app_id
  end
end
