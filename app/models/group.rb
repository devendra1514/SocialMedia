class Group < ApplicationRecord
  self.table_name = :groups
  self.primary_key = :group_id

  include ThumbnailConcern

  has_one_attached :logo

  # Associations
  belongs_to :creator, class_name: :User, foreign_key: :user_id
  has_many :group_memberships, class_name: :GroupMembership, dependent: :destroy
  has_many :members, through: :group_memberships
  has_many :messages, class_name: :GroupMessage, foreign_key: :group_id, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :username, uniqueness: { case_sensitive: false }, username: true, length: { in: 5..20 }
  validates :logo, mime_type: { media_type: 'image', max_size: 5.megabytes }, if: -> { logo.attached? }

  # Callbacks
  before_validation :set_username, if: -> { new_record? }
  after_create_commit :add_creator_as_member
  after_commit -> {
    process_thumbnail(logo) if logo.attached? && logo.blob.saved_changes?
  }, on: [:create, :update]

  private

  def set_username
    self.username ||= SecureRandom.hex(10)
  end

  def add_creator_as_member
    group_memberships.create(user_id: user_id)
  end
end
