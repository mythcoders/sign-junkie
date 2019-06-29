# frozen_string_literal: true

FactoryBot.define do
  factory :refund do
    invoice
    customer_credit
    amount { Faker::Number.decimal(2)  }
  end
end
