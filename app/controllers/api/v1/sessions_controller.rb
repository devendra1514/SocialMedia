module Api::V1
  class SessionsController < Api::AppController
    skip_before_action :validate_token!, only: %i[login_with_password login_with_otp]
    before_action :set_user, only: %i[login_with_password]

    def login_with_password
      return render json: { error: ACCOUNT_VERIFICATION_WARNING }, status: :bad_request unless @user.verified
      if @user.authenticate(params[:password])
        @token = JsonWebToken.encode(id: @user.user_id)
      else
        render json: { error: "Password don't match" }, status: :bad_request
      end
    end

    def login_with_otp
      full_phone_number = Phonelib.parse(params[:full_phone_number]).full_e164
      otp_validate_service = OtpValidateService.new(full_phone_number, 'login', params[:code])
      if otp_validate_service.valid_code?
        @user = otp_validate_service.user
        @user.update(verified: true)
        @token = JsonWebToken.encode(id: @user.user_id)
      else
        render json: { error: otp_validate_service.error }, status: :bad_request
      end
    end
  end
end
