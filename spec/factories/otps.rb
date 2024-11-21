FactoryBot.define do
  factory :otp do
    user { create(:user) }
    code { '0000' }
    purpose { 'login' }
  end
end
