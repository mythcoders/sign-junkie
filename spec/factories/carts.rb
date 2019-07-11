# frozen_string_literal: true

FactoryBot.define do
  factory :cart_seat, class: Cart do
    user
    association :description, factory: :seat_item
  end

  factory :cart_reservation, class: Cart do
    user
    association :description, factory: :reservation_item
  end

  factory :cart_gift_card, class: Cart do
    user
    association :description, factory: :gift_card_item
  end

  factory :gifted_cart_seat, class: Cart do
    user
    association :description, factory: :gifted_seat_item
  end
end
