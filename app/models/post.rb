class Post < ApplicationRecord
  self.table_name = :posts
  self.primary_key = :post_id

  include ThumbnailConcern

  has_one_attached :media

  # Associations
  belongs_to :user, class_name: :User, foreign_key: :user_id, counter_cache: :posts_count
  has_many :comments, as: :commentable, class_name: :Comment, dependent: :destroy
  has_many :likes, as: :likeable, class_name: :Like, dependent: :destroy

  # Validations
  validates :title, presence: true
  validates :media, mime_type: { media_type: %w[image video], max_size: 45.megabytes }, if: -> { media.attached? }

  # Scopes
  default_scope -> { order(:created_at) }

  # Callbacks
  after_commit -> {
    process_thumbnail(media) if media.attached? && media.blob.saved_changes?
  }, on: [:create, :update]
end
