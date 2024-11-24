module UserSearchConcern
  extend ActiveSupport::Concern

  included do
    def self.search_with_name_or_username(q)
      where("users.name ILIKE ? OR users.username ILIKE ?", "%#{q}%", "%#{q}%")
    end

    def self.search_with_name(q)
      where("users.name ILIKE ?", "%#{q}%")
    end

    def self.search_with_username(q)
      where("users.username ILIKE ?", "%#{q}%")
    end
  end
end
