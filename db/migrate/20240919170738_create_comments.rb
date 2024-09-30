class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments, id: false do |t|
      t.bigint :comment_id, primary_key: true
      t.string :title
      t.references :commentable, polymorphic: true, null: false
      t.integer :level, null: false, default: 0
      t.bigint :likes_count, default: 0
      t.bigint :comments_count, default: 0
      t.references :user, null: false, foreign_key: { primary_key: :user_id }

      t.timestamps
    end
  end
end
