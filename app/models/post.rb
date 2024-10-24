class Post < ApplicationRecord
  include ThumbnailConcern

  self.table_name = :posts
  self.primary_key = :post_id

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings do
    mappings dynamic: 'false' do
      indexes :title, type: 'text', analyzer: 'english'
    end
  end

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
  after_create_commit -> { process_thumbnail(media) }
end
