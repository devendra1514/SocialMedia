module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_current_user
    end

    private
      def find_current_user
        token = request.headers[:token] || request.params[:token]
        unless token
          handle_error(I18n.t('jwt.token_missing'))
        end

        decode_hash = JsonWebToken.decode(token)
        @id = decode_hash[:id]
        @current_user = User.find(@id)
      rescue ActiveRecord::RecordNotFound
        handle_error(I18n.t('jwt.account_deleted'))
      rescue JWT::ExpiredSignature
        handle_error(I18n.t('jwt.session_expired'))
      rescue JWT::DecodeError
        handle_error(I18n.t('jwt.invalid_token'))
      end

      def handle_error(message)
        Rails.logger.error(message)
        reject_unauthorized_connection
      end
  end
end
