class CreateRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :roles, id: false do |t|
      t.string :role_id, primary_key: true
    end
  end
end
