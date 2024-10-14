class CreateLikes < ActiveRecord::Migration[7.1]
  def change
    create_table :likes, id: false do |t|
      t.bigint :like_id, primary_key: true
      t.references :user, null: false, foreign_key: { primary_key: :user_id }
      t.references :likeable, polymorphic: true, null: false

      t.timestamps
    end
    add_index :likes, [:user_id, :likeable_type, :likeable_id], unique: true
    add_column :posts, :likes_count, :bigint, default: 0
    add_column :comments, :likes_count, :bigint, default: 0
  end
end
