# frozen_string_literal: true

FactoryBot.define do
  factory :workshop_type do
    name { Faker::Lorem.characters(number: 8) }
    active { true }
    default_total_seats { 21 }
    default_single_seat_allow { true }
    default_reservation_allow { true }
    default_reservation_allow_multiple { true }
    default_reservation_cancel_minimum_not_met { true }
    default_reservation_price { Faker::Commerce.material }
    default_reservation_maximum { 18 }
    default_reservation_minimum { Faker::Number.between(from: 1, to: default_reservation_maximum) }

    trait :no_reservations do
      default_reservation_allow { false }
    end

    trait :no_seats do
      default_single_seat_allow { false }
    end
  end
end
