class Otp < ApplicationRecord
  self.table_name = :otps
  self.primary_key = :otp_id

	# Associations
  belongs_to :user, class_name: :User, foreign_key: :user_id

  # Validations
  validates :code, :purpose, presence: true
  enum purpose: {
    login: 0,
    forgot_password: 1
  }

  # Callbacks
  before_validation :generate_code
  after_create_commit :send_code

  private

  def generate_code
    self.code = 4.times.map { rand(10) }.join('')
  end

  def send_code
    # TwilioService.send_sms(user.full_phone_number, self.code)
  end
end
