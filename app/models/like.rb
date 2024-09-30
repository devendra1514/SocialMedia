class Like < ApplicationRecord
  self.table_name = :likes
  self.primary_key = :like_id
  
  # Associations
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :likeable, polymorphic: true, counter_cache: :likes_count

  # Validations
  validates :user, uniqueness: { scope: :likeable, message: 'already liked' }
end
