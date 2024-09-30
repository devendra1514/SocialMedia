class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts, id: false do |t|
      t.bigint :post_id, primary_key: true
      t.string :title
      t.bigint :likes_count, default: 0
      t.bigint :comments_count, default: 0
      t.references :user, null: false, foreign_key: { primary_key: :user_id }

      t.timestamps
    end
  end
end
