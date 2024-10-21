class Moment < ApplicationRecord
  include ThumbnailConcern

  self.table_name = :moments
  self.primary_key = :moment_id

  has_one_attached :media

  # Associations
  belongs_to :user, class_name: :User, foreign_key: :user_id, counter_cache: :moments_count
  has_many :comments, as: :commentable, class_name: :Comment, dependent: :destroy
  has_many :likes, as: :likeable, class_name: :Like, dependent: :destroy
  has_many :views, as: :viewable, class_name: :View, dependent: :destroy

  # Validations
  validates :title, presence: true
  validates :media, presence: true, mime_type: { media_type: %w[image video], max_size: 45.megabytes }

  scope :all_moments, -> { includes(:user) }
  scope :following_moments, -> (current_user) {
    includes(:user).where(user: current_user.followings)
  }
  scope :user_moments, -> (user) {
    user.moments
  }

  # Callbacks
  after_create_commit -> { process_thumbnail(media) }
end
