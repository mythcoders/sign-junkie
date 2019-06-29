# frozen_string_literal: true

FactoryBot.define do
  factory :seat do
    workshop
    customer
    seat_item
    prepped { false }
    notified { false }
  end
end
