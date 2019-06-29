# frozen_string_literal: true

FactoryBot.define do
  factory :cart_seat, class: Cart do
    customer
    seat_item
  end

  factory :cart_reservation, class: Cart do
    customer
    reservation_item
  end

  factory :cart_gift_card, class: Cart do
    customer
    gift_card_item
  end
end
