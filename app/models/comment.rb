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
  before_validation :check_and_set_level

  # Scopes
  default_scope { order(created_at: :desc) }

  private

  def check_and_set_level
    if commentable.is_a?(Post)
      self.level = 0
    elsif commentable.is_a?(Comment)
      if commentable.level >= 1
        errors.add(:base, "can't comment more than one")
      else
        lev = commentable.level
        self.level = lev.nil? ? 0 : lev + 1
      end
    end
  end
end
