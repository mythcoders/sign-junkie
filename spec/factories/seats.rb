# frozen_string_literal: true

FactoryBot.define do
  factory :seat do
    association :workshop, factory: :bookable_workshop
    customer
    prepped { false }
    notified { false }

    before(:create) { |seat| seat.description = create(:seat_item, workshop: seat.workshop) }
  end
end
