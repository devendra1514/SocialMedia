class Otp < ApplicationRecord
  self.table_name = :otps
  self.primary_key = :otp_id

  PURPOSES = { login: 0, forgot_password: 1 }.freeze

	# Associations
  belongs_to :user, class_name: :User, foreign_key: :user_id

  # Validations
  validates :code, presence: true, format: { with: /\A\d+\z/ }
  validates :purpose, presence: true, inclusion: { in: PURPOSES.keys.map(&:to_s) }

  # Enum
  enum purpose: PURPOSES

  # Callbacks
  before_validation :generate_code
  after_create_commit :send_code

  private

  def generate_code
    # self.code ||= 4.times.map { rand(10) }.join('')
    self.code ||= '1212'
  end

  def send_code
    # TwilioService.send_sms(user.full_phone_number, self.code)
  end
end
