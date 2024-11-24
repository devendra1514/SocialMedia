class GroupMembership < ApplicationRecord
  self.table_name = :group_memberships
  self.primary_key = :group_membership_id

  # Associations
  belongs_to :member, class_name: :User, foreign_key: :user_id
  belongs_to :group, class_name: :Group, foreign_key: :group_id

  # Validations
  validates :member, uniqueness: { scope: :group }

  # Callbacks
end
