class CreateOtps < ActiveRecord::Migration[7.1]
  def change
    create_table :otps, id: false do |t|
      t.bigint :otp_id, primary_key: true
      t.string :code, null: false
      t.integer :purpose, null: false
      t.references :user, null: false, foreign_key: { primary_key: :user_id }
      t.datetime :send_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.boolean :used, null: false, default: false
    end
  end
end
