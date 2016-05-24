class CreateCooperators < ActiveRecord::Migration
  def change
    create_table :cooperators do |t|
      t.string :name
      t.string :email
      t.string :belongings
      t.string :password_digest
      t.string :remember_digest

      t.timestamps null: false
    end

  end
end
