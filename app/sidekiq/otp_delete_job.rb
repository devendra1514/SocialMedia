class OtpDeleteJob
  include Sidekiq::Job

  def perform(*args)
    Otp.where('send_at <= ?', OTP_EXPIRATION_TIME.ago)
      .in_batches(of: 500) do |otps_batch|

      otps_batch.delete_all
    end
  end
end
