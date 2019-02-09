FactoryBot.define do
  factory :customization do
    name { Faker::Lorem.word }
    category { Faker::Lorem.word }
  end
end
