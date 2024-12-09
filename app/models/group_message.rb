class GroupMessage < ApplicationRecord
  self.table_name = :group_messages
  self.primary_key = :group_message_id

  # Associations
  belongs_to :sender, class_name: :User, foreign_key: :sender_id
  belongs_to :group, class_name: :Group, foreign_key: :group_id

  # Validations
  validates :content, presence: true
  validate :validate_sender_as_member

  # Scopes
  default_scope -> { order(created_at: :desc) }

  private

  def validate_sender_as_member
    (errors.add(:sender, :not_member) unless group.members.exists?(user_id: sender.user_id)) if sender.present?
  end
end
