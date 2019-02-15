FactoryBot.define do
  factory :address do
    nickname { Faker::Address.community }
    street { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    zip_code { Faker::Address.zip_code }
    country { 'US' }
  end
end
