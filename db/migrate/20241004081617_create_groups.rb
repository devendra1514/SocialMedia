class CreateGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :groups, id: false do |t|
      t.bigint :group_id, primary_key: true
      t.string :name
      t.string :username
      t.references :user, null: false, foreign_key: { primary_key: :user_id }

      t.timestamps
    end
    add_index :groups, :username, unique: true
  end
end
