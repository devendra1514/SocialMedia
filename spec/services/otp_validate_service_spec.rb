require 'rails_helper'

RSpec.describe OtpValidateService, type: :service do
  let(:user) { create(:user) }
  let(:login_purpose) { 'login' }

  before do
    user.update(verified: true)
  end

  describe '#valid_code?' do
    context 'when account is not found' do
      it 'returns error message "account not found"' do
        service = OtpValidateService.new('wrong_phone_number', login_purpose, nil)
        expect(service.valid_code?).to be(false)
        expect(service.error).to eq(I18n.t('user.not_found'))
      end
    end

    context 'when account is found' do
      context 'when OTP is not sent' do
        it 'returns error message "OTP not sent"' do
          user.otps.destroy_all
          service = OtpValidateService.new(user.full_phone_number, login_purpose, nil)
          expect(service.valid_code?).to be(false)
          expect(service.error).to eq(I18n.t('otp.not_sent'))
        end
      end

      context 'when OTP is sent' do
        it 'but OTP is expired, returns error message "OTP expired"' do
          user.otps.last.update(send_at: 5.minutes.ago)
          service = OtpValidateService.new(user.full_phone_number, login_purpose, user.otps.last.code)
          expect(service.valid_code?).to be(false)
          expect(service.error).to eq(I18n.t('otp.code_expired'))
        end

        it 'but OTP is invalid, returns error message "OTP invalid"' do
          service = OtpValidateService.new(user.full_phone_number, login_purpose, 'wrong_code')
          expect(service.valid_code?).to be(false)
          expect(service.error).to eq(I18n.t('otp.code_invalid'))
        end

        it 'and OTP is valid, returns true' do
          valid_otp = user.otps.last
          service = OtpValidateService.new(user.full_phone_number, login_purpose, valid_otp.code)
          expect(service.valid_code?).to be(true)
        end
      end
    end
  end
end
