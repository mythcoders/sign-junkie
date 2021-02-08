# frozen_string_literal: true

FactoryBot.define do
  factory :tax_rate do
    rate { Faker::Number.between(from: 0.00, to: 1.00) }
    effective_date { DateTime.yesterday }
  end
end
