class CreateGroupMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :group_messages, id: false do |t|
      t.bigint :group_message_id, primary_key: true
      t.string :content
      t.references :sender, null: false, foreign_key: { to_table: :users, primary_key: :user_id }
      t.references :group, null: false, foreign_key: { primary_key: :group_id }

      t.timestamps
    end
  end
end
