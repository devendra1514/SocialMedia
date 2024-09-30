class Follow < ApplicationRecord
  self.table_name = :follows
  self.primary_key = :follow_id

  # Associations
  belongs_to :follower, class_name: 'User', foreign_key: 'follower_id'
  belongs_to :followed, class_name: 'User', foreign_key: 'followed_id'

  # Validations
  validates :follower, uniqueness: { scope: :followed, message: 'already followed' }
  validate :check_own_follow

  private

  def check_own_follow
    if follower&.user_id == followed&.user_id
      errors.add(:base, "Don't follow yourself")
    end
  end
end
