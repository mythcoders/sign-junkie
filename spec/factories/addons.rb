# frozen_string_literal: true

FactoryBot.define do
  factory :addon do
    name { Faker::Lorem.word }
    price { Faker::Number.decimal(2) }
  end
end
