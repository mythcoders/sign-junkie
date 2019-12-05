# frozen_string_literal: true

FactoryBot.define do
  factory :refund do
    invoice
    customer_credit
    amount { Faker::Commerce.material }
  end
end
