class GroupMessage < ApplicationRecord
  self.table_name = :group_messages
  self.primary_key = :group_message_id

  # Associations
  belongs_to :sender, class_name: :User, foreign_key: :sender_id
  belongs_to :group, class_name: :Group, foreign_key: :group_id

  # Validations
  validates :content, presence: true

  # Scopes
  default_scope -> { order(created_at: :asc) }
end
