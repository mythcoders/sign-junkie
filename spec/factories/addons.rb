# frozen_string_literal: true

FactoryBot.define do
  factory :addon do
    name { Faker::Lorem.characters(25) }
    price { Faker::Commerce.material }
  end
end
