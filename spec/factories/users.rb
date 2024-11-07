FactoryBot.define do
  factory :user, class: 'User' do
    name { Faker::Name.name }
    username { Faker::Internet.username(specifier: name, separators: %w(. _ )) }
    full_phone_number { "+919999999999" }
    password { 'password' }
    role { Role.find_or_create_by(role_id: 'user') }
    verified { true }
  end
end
