# frozen_string_literal: true

FactoryBot.define do
  factory :tax_rate do
    rate { Faker::Number.between(0.00, 1.00) }
    effective_date { DateTime.now }
  end
end
