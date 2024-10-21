class User < ApplicationRecord
  include ThumbnailConcern

  self.table_name = :users
  self.primary_key = :user_id

  has_secure_password

  has_one_attached :avatar

  # Associations
  belongs_to :role, class_name: :Role, foreign_key: :role_id
  has_many :otps, class_name: :Otp, foreign_key: :user_id, dependent: :destroy
  has_many :posts, class_name: :Post, foreign_key: :user_id, dependent: :destroy
  has_many :comments, class_name: :Comment, foreign_key: :user_id, dependent: :destroy

  has_many :likes, class_name: :Like, foreign_key: :user_id, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :likeable, source_type: :Post
  has_many :liked_comments, through: :likes, source: :likeable, source_type: :Comment
  has_many :liked_moments, through: :likes, source: :likeable, source_type: :Moment

  has_many :follows_as_follower, class_name: :Follow, foreign_key: :follower_id, dependent: :destroy
  has_many :followings, through: :follows_as_follower, source: :followed

  has_many :follows_as_followed, class_name: :Follow, foreign_key: :followed_id, dependent: :destroy
  has_many :followers, through: :follows_as_followed, source: :follower

  has_many :created_groups, class_name: :Group, foreign_key: :user_id, dependent: :destroy
  has_many :group_memberships, class_name: :GroupMembership
  has_many :groups, through: :group_memberships, dependent: :destroy
  has_many :group_messages, class_name: :GroupMessage, foreign_key: :sender_id, dependent: :destroy
  has_many :send_messages, class_name: :DirectMessage, foreign_key: :sender_id, dependent: :destroy
  has_many :recieved_messages, class_name: :DirectMessage, foreign_key: :recipient_id, dependent: :destroy
  has_many :moments, class_name: :Moment, foreign_key: :user_id, dependent: :destroy
  has_many :views, class_name: :View, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :full_phone_number, uniqueness: true, phone: true
  validates :username, uniqueness: { case_sensitive: false }, username: true
  validates :avatar, mime_type: { media_type: %w[image], max_size: 10.megabytes }, if: -> { avatar.attached? }

  # Callbacks
  before_validation :format_phone_number
  before_create :set_verified
  after_create_commit :send_otp
  after_create_commit -> { process_thumbnail(avatar) }

  private

  def format_phone_number
    self.full_phone_number = Phonelib.parse(self.full_phone_number).full_e164
  end

  def send_otp
    otps.create(purpose: 'login', send_at: Time.current)
  end

  def set_verified
    self.verified = false
  end
end
