module Api::V1
  class OtpsController < Api::AppController
    skip_before_action :validate_token!, only: %i[new create]
    before_action :set_user, only: %i[create]

    def new; end

    def create
      otp = @user.otps.new(otp_params)
      if otp.save
        render json: { message: I18n.t('otp.send_success') }
      else
        render json: { error: otp.errors }, status: :unprocessable_entity
      end
    end

    private

    def otp_params
      params.permit(:purpose)
    end
  end
end
