FactoryBot.define do
  factory :user, aliases: [:author] do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    confirmed_at { Date.today }

    trait :customer do
      role { 'customer' }
    end

    trait :employee do
      role { 'employee' }
    end
  end
end
