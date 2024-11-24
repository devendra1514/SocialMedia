class Comment < ApplicationRecord
  self.table_name = :comments
  self.primary_key = :comment_id

  # Associations
  belongs_to :commentable, polymorphic: true, counter_cache: :comments_count
  belongs_to :user, class_name: :User, foreign_key: :user_id, counter_cache: :comments_count
  has_many :comments, as: :commentable, class_name: :Comment, dependent: :destroy
  has_many :likes, as: :likeable, class_name: :Like, dependent: :destroy

  # Validations
  validates :title, presence: true

  # Callbacks
  before_validation :set_level_and_validate

  # Scopes
  default_scope { order(created_at: :desc) }

  private

  def set_level_and_validate
    if commentable.is_a?(Comment)
      lev = commentable.level
      self.level = lev + 1
      if self.level >= 2
        errors.add(:base, :invalid_comment_level)
      end
    else
      self.level = 0
    end
  end
end
