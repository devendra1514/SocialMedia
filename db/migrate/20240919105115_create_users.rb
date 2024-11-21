class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: false do |t|
      t.bigint :user_id, primary_key: true
      t.string :name, null: false
      t.string :full_phone_number, null: false
      t.string :username, null: false
      t.string :password_digest, null: false
      t.boolean :verified, null: false, default: false
      t.references :role, null: false, foreign_key: { primary_key: :role_id }

      t.timestamps
    end
    add_index :users, :full_phone_number, unique: true
    add_index :users, :username, unique: true
  end
end
