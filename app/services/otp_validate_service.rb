class OtpValidateService
  attr_accessor :user, :otp, :error

  def initialize(full_phone_number, purpose, code)
    @user = User.find_by(full_phone_number: full_phone_number)
    otp = @user&.otps&.send(purpose)&.last
    @otp = otp&.used == true ? nil : otp
    @code = code
    @error = nil
  end

  def valid_code?
    return add_error(I18n.t('user.not_found')) if @user.nil?
    return add_error(I18n.t('otp.not_sent')) if @otp.nil?
    return add_error(I18n.t('otp.code_expired')) if otp_expired?
    return add_error(I18n.t('otp.code_invalid')) unless valid_otp_code?
    true
  end

  private

  def otp_expired?
    @otp.send_at <= OTP_EXPIRATION_TIME.ago
  end

  def valid_otp_code?
    @otp.code == @code
  end

  def add_error(error)
    @error = error
    false
  end
end
