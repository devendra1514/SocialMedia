class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts, id: false do |t|
      t.bigint :post_id, primary_key: true
      t.string :title
      t.references :user, null: false, foreign_key: { primary_key: :user_id }

      t.timestamps
    end
    add_column :users, :posts_count, :bigint, default: 0
  end
end
