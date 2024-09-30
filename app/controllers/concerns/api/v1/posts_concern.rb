module Api::V1
  module PostsConcern
    extend ActiveSupport::Concern
    included do
      def serialization_options
        { params: { current_user: current_user } }
      end
    end
  end
end
