class CreateDirectMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :direct_messages, id: false do |t|
      t.bigint :direct_message_id, primary_key: true
      t.string :content
      t.references :sender, null: false, foreign_key: { to_table: :users, primary_key: :user_id }
      t.references :recipient, null: false, foreign_key: { to_table: :users, primary_key: :user_id }

      t.timestamps
    end
  end
end
