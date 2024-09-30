class CreateFollows < ActiveRecord::Migration[7.1]
  def change
    create_table :follows, id: false do |t|
      t.bigint :follow_id, primary_key: true
      t.references :follower, null: false, foreign_key: { to_table: :users, primary_key: :user_id }
      t.references :followed, null: false, foreign_key: { to_table: :users, primary_key: :user_id }
    end
    
    add_index :follows, [:follower_id, :followed_id], unique: true
  end
end
