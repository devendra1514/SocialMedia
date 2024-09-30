class TwilioService
  class << self
    def send_sms(full_phone_number, text_content)
      client = ::Twilio::REST::Client.new(account_sid, auth_token)
      client.messages.create({
                               from: from,
                               to: Phonelib.parse(full_phone_number).full_e164,
                               body: text_content
                             })
    end

    def account_sid
      Rails.application.credentials.dig(:twilio, :account_sid) || ENV['ACCOUNT_SID']
    end

    def auth_token
      Rails.application.credentials.dig(:twilio, :auth_token) || ENV['AUTH_TOKEN']
    end

    def from
      Rails.application.credentials.dig(:twilio, :from) || ENV['FROM']
    end
  end
end