class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :number
      t.string :role
      t.string :department
      t.string :password_digest
      t.string :remember_digest
      t.string :company
      t.string :major

      t.string :activation_digest
      t.boolean :activated, default: false
      t.datetime :activated_at
      t.string :reset_digest
      t.string :reset_sent_at

      t.boolean :admin, default: false
      t.boolean :developer, default: false

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
