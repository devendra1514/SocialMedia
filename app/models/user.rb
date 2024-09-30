class User < ApplicationRecord
  self.table_name = :users
  self.primary_key = :user_id

  has_secure_password

  # Associations
  belongs_to :role, class_name: 'Role', foreign_key: 'role_id'
  has_many :otps, class_name: 'Otp', foreign_key: 'user_id', dependent: :destroy
  has_many :posts, class_name: 'Post', foreign_key: 'user_id', dependent: :destroy
  has_many :comments, class_name: 'Comment', foreign_key: 'user_id', dependent: :destroy
  has_many :likes, class_name: 'Like', foreign_key: 'user_id', dependent: :destroy

  has_many :liked_posts, through: :likes, source: :likeable, source_type: 'Post'
  has_many :liked_comments, through: :likes, source: :likeable, source_type: 'Comment'

  has_many :follows_as_follower, foreign_key: :follower_id, class_name: 'Follow', dependent: :destroy
  has_many :followings, through: :follows_as_follower, source: :followed

  has_many :follows_as_followed, foreign_key: :followed_id, class_name: 'Follow', dependent: :destroy
  has_many :followers, through: :follows_as_followed, source: :follower

  # Validations
  validates :name, presence: true
  validates :full_phone_number, uniqueness: true, phone: true
  validates :username, uniqueness: { case_sensitive: false }, username: true

  # Callbacks
  after_create :send_otp
  before_create :set_verified
  before_validation :format_phone_number

  private

  def format_phone_number
    self.full_phone_number = Phonelib.parse(self.full_phone_number).full_e164
  end

  def send_otp
    otps.create(purpose: 'signup', send_at: Time.current)
  end

  def set_verified
    self.verified = false
  end
end
