class CreateGroupMemberships < ActiveRecord::Migration[7.1]
  def change
    create_table :group_memberships, id: false do |t|
      t.bigint :group_membership_id, primary_key: true
      t.references :user, null: false, foreign_key: { primary_key: :user_id }
      t.references :group, null: false, foreign_key: { primary_key: :group_id }

      t.timestamps
    end

    add_index :group_memberships, [:user_id, :group_id], unique: true
  end
end
