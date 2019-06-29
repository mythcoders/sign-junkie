# frozen_string_literal: true

FactoryBot.define do
  factory :customer_credit do
    customer
    starting_amount { Faker::Number.decimal(2) }
    balance { starting_amount }

    trait :expired do
      expiration_date { Faker::Date.backward(14) }
    end

    trait :unexpired do
      expiration_date { Faker::Date.forward(23) }
    end
  end
end
