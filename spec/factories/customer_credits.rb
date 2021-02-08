# frozen_string_literal: true

FactoryBot.define do
  factory :customer_credit do
    customer
    starting_amount { Faker::Commerce.material }
    balance { starting_amount }

    trait :expired do
      expiration_date { Faker::Date.backward(days: 14) }
    end

    trait :unexpired do
      expiration_date { Faker::Date.forward(days: 23) }
    end
  end
end
