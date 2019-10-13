# frozen_string_literal: true

FactoryBot.define do
  factory :seat do
    association :workshop, factory: :bookable_workshop
    # association :description, factory: :seat_item
    customer
    prepped { false }
    notified { false }

    before(:create) { |seat| seat.description = create(:seat_item, workshop: seat.workshop) }

    trait :paid do
      after(:create) do |seat|
        create(:invoice, :paid,
               customer: seat.customer,
               items: [create(:invoice_item, item_description_id: seat.item_description_id)])
      end
    end
  end
end
