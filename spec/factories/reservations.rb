# frozen_string_literal: true

FactoryBot.define do
  factory :reservation do
    workshop
    reservation_item
    customer
    payment_plan { '' }
  end
end
