module JsonWebTokenValidation
  extend ActiveSupport::Concern

  included do
    before_action :validate_token!
  end

  def validate_token!
    token = request.headers[:token] || params[:token]
    return render_error(I18n.t('jwt.token_missing')) unless token

    decode_token(token)
    verify_user
  rescue ActiveRecord::RecordNotFound
    render_error(I18n.t('jwt.account_deleted'))
  rescue JWT::ExpiredSignature
    render_error(I18n.t('jwt.session_expired'))
  rescue JWT::DecodeError
    render_error(I18n.t('jwt.invalid_token'))
  end

  def current_user
    @current_user
  end

  private

  def decode_token(token)
    decode_hash = JsonWebToken.decode(token)
    @id = decode_hash[:id]
    @current_user = User.find(@id)
  end

  def verify_user
    if @current_user.verified
      return true
    else
      render_error(I18n.t('jwt.account_not_verified'))
    end
  end

  def render_error(message)
    render json: { error: message }, status: :bad_request
  end
end
