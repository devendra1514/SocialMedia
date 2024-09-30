module JsonWebTokenValidation
  extend ActiveSupport::Concern

  included do
    before_action :validate_token!
  end

  def validate_token!
    token = request.headers[:token] || params[:token]
    decode_hash = JsonWebToken.decode(token)
    @id = decode_hash[:id]
    @current_user = User.find(@id)
    render json: { error: 'Account is not verified, login with otp to verified' } unless @current_user.verified
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Account is deleted' }
  rescue JWT::ExpiredSignature
    render json: { error: 'Session expired' }
  rescue JWT::DecodeError => e
    render json: { error: 'Something went wrong' }
  end

  def current_user
    @current_user
  end
end
