class Moment < ApplicationRecord
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
end
