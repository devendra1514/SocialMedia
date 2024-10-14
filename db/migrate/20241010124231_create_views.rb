class CreateViews < ActiveRecord::Migration[7.1]
  def change
    create_table :views, id: false do |t|
      t.bigint :view_id, primary_key: true
      t.references :user, null: false, foreign_key: { to_table: :users, primary_key: :user_id }
      t.references :viewable, polymorphic: true, null: false

      t.timestamps
    end
    add_index :views, [:user_id, :viewable_type, :viewable_id], unique: true
    add_column :moments, :views_count, :bigint, default: 0
  end
end
