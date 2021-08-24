# frozen_string_literal: true

FactoryBot.define do
  factory :reservation do
    association :workshop, factory: :bookable_workshop
    association :description, factory: :reservation_item
    host
    payment_plan { "host" }
  end
end
