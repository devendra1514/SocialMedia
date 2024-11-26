class DirectMessage < ApplicationRecord
  self.table_name = :direct_messages
  self.primary_key = :direct_message_id

  # Associations
  belongs_to :sender, class_name: :User, foreign_key: :sender_id
  belongs_to :recipient, class_name: :User, foreign_key: :recipient_id

  # Validations
  validates :content, presence: true

  # Scopes
  default_scope -> { order(created_at: :asc) }
end
