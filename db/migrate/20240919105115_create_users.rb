class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: false do |t|
      t.bigint :user_id, primary_key: true
      t.string :name, null: false
      t.string :full_phone_number, null: false
      t.string :username, null: false
      t.bigint :posts_count, default: 0
      t.bigint :comments_count, default: 0
      t.string :password_digest, null: false
      t.boolean :verified, null: false, default: false

      t.timestamps
    end
    add_index :users, :full_phone_number, unique: true
    add_index :users, :username, unique: true
    add_column :users, :role_id, :string, null: false
    add_foreign_key :users, :roles, column: :role_id, primary_key: :role_id
    add_index :users, :role_id
  end
end
