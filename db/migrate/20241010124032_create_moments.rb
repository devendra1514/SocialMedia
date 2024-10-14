class CreateMoments < ActiveRecord::Migration[7.1]
  def change
    create_table :moments, id: false do |t|
      t.bigint :moment_id, primary_key: true
      t.string :title
      t.bigint :likes_count, default: 0
      t.bigint :comments_count, default: 0
      t.references :user, null: false, foreign_key: { to_table: :users, primary_key: :user_id }

      t.timestamps
    end
    add_column :users, :moments_count, :bigint, default: 0
  end
end
