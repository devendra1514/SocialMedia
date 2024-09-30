class Role < ApplicationRecord
  self.table_name = :roles
  self.primary_key = :role_id

  # Associations
  has_many :users, class_name: 'User', foreign_key: 'role_id', dependent: :destroy

  # Validations
end
