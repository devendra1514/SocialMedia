module UserSearchConcern
  extend ActiveSupport::Concern

  included do
    def self.search_with_name_or_username(q)
      where("users.name ILIKE ? OR users.username ILIKE ?", "%#{q}%", "%#{q}%")
    end
  end
end
