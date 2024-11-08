module Api::V1
  class PasswordsController < Api::AppController
    skip_before_action :validate_token!, only: %i[create]

    def create
      full_phone_number = Phonelib.parse(params[:full_phone_number]).full_e164
      otp_validate_service = OtpValidateService.new(full_phone_number, 'forgot_password', params[:code])
      if otp_validate_service.valid_code?
        user = otp_validate_service.user
        if user.update(password: params[:password], password_confirmation: params[:password_confirmation])
          otp_validate_service.otp.update(used: true)
          render json: { message: I18n.t('password.update_success') }
        else
          render json: { error: otp_validate_service.user.errors }, status: :unprocessable_entity
        end
      else
        render json: { error: otp_validate_service.error }, status: :bad_request
      end
    end
  end
end
