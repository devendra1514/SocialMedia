class View < ApplicationRecord
  self.table_name = :views
  self.primary_key = :view_id

  # Associations
  belongs_to :user, class_name: :User, foreign_key: :user_id
  belongs_to :viewable, polymorphic: true, counter_cache: :views_count

  # Validations
  validates :user, uniqueness: { scope: :viewable, message: 'already viewed' }
end
