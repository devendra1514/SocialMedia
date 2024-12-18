FactoryBot.define do
  factory :user, class: 'User' do
    name { Faker::Name.name }
    username { Faker::Internet.username(specifier: name[0..17], separators: %w(. _ )).strip }
    full_phone_number { "+9199#{rand(10000000..99999999)}" }
    password { 'password' }
    role { Role.find_or_create_by(name: 'user') }
    verified { true }
  end
end
