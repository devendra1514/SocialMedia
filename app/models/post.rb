class Post < ApplicationRecord
  self.table_name = :posts
  self.primary_key = :post_id

  # Associations
  belongs_to :user, class_name: 'User', foreign_key: 'user_id', counter_cache: :posts_count
  has_many :comments, as: :commentable, class_name: 'Comment', dependent: :destroy
  has_many :likes, as: :likeable, class_name: 'Like', dependent: :destroy

  # Validations
  validates :title, presence: true

  # Scopes
  scope :all_posts, -> { includes(:user) }
  scope :following_posts, -> (current_user) {
    includes(:user).where(user: current_user.followings)
  }
  scope :user_posts, -> (user) {
    user.posts
  }
end
