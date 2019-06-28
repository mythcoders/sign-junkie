# frozen_string_literal: true

FactoryBot.define do
  factory :payment do
    # method { 'credit_card' }
    amount { Faker::Number.decimal(2) }

    # trait :gift_card do
    #   method { 'gift_card' }
    # end
  end
end
