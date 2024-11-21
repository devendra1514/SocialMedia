require 'rails_helper'
RSpec.describe OtpDeleteJob, type: :job do
  let(:expired_otps) { create_list(:otp, 5, send_at: 2.days.ago) }
  let(:used_otps) { create_list(:otp, 5, used: true) }
  let(:valid_otps) { create_list(:otp, 1, used: false) }

  describe '#perform' do
    it 'deletes only expired_otps' do
      expired_otps
      expect {
        described_class.new.perform
      }.to change(Otp, :count).by(-expired_otps.size)
    end

    it 'not deletes used_otps' do
      used_otps
      expect {
        described_class.new.perform
      }.to change(Otp, :count).by(0)
    end

    it 'not deletes valid_otps' do
      valid_otps
      expect {
        described_class.new.perform
      }.to change(Otp, :count).by(0)
    end

    it 'process otps in batches' do
      expect(Otp).to receive_message_chain(:where, :in_batches).with(of: 500)
      described_class.new.perform
    end
  end
end
