class Role < ApplicationRecord
  self.table_name = :roles
  self.primary_key = :role_id

  ROLE_NAME = %w[user]

  # Associations
  has_many :users, class_name: :User, foreign_key: :role_id, dependent: :destroy

  # Validations
  validates :name, presence: true, uniqueness: true, inclusion: { in: ROLE_NAME }
end
