require 'rails_helper'

RSpec.describe Otp, type: :model do
  let(:user) { create(:user) }
  let(:otp) { build(:otp, user: user, purpose: 'login') }

  describe 'associations' do
    it { should belong_to(:user).class_name('User').with_foreign_key(:user_id) }
  end

  describe 'validations' do
    context 'code format' do
      it 'is valid with numeric code' do
        otp.code = '1234'
        expect(otp).to be_valid
      end

      it 'is invalid with non-numeric code' do
        otp.code = 'abcd'
        expect(otp).not_to be_valid
        expect(otp.errors[:code]).to include(I18n.t('activerecord.errors.models.otp.attributes.code.invalid'))
      end
    end

    context 'purpose inclusion' do
      it 'is valid with a valid purpose' do
        otp.purpose = 'login'
        expect(otp).to be_valid
      end

      it 'is invalid with an invalid purpose' do
        expect { otp.purpose = 'invalid-purpose' }.to raise_error(ArgumentError, "'invalid-purpose' is not a valid purpose")
      end
    end
  end

  describe 'callbacks' do
    context 'before validation' do
      it 'generates a code if not provided' do
        otp.code = nil
        otp.save
        expect(otp.code).not_to be_nil
      end

      it 'does not overwrite an existing code' do
        otp.code = '5678'
        otp.save
        expect(otp.code).to eq('5678')
      end
    end

    context 'after create' do
      it 'calls the send_code method' do
      end
    end
  end

  describe 'enum' do
    it 'maps purposes correctly' do
      expect(Otp.purposes).to eq({ 'login' => 0, 'forgot_password' => 1 })
    end
  end
end
