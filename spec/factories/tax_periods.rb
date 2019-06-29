# frozen_string_literal: true

FactoryBot.define do
  factory :tax_period do
    start_date { Faker::Date.backward(14) }
    end_date { start_date + 6.months }
    estiamted_due { 0.00}
    amount_paid { 0.00 }
  end
end
