class CreateRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :roles, id: false do |t|
      t.bigint :role_id, primary_key: true
      t.string :name, null: false
    end
    add_index :roles, :name, unique: true
  end
end
