# frozen_string_literal: true

module CartService
  # attempting to add a seat to their cart
  class SimilarSeat
    def initialize(cart_item, current_user)
      @item = cart_item
      @current_user = current_user
    end

    def self.check(cart_item, current_user)
      new(cart_item, current_user).similar_cart_items?
    end

    def similar_cart_items?
      case @item.guest_type
      when "other", "child"
        check_cart_seats_by_first_and_last_name
      else
        check_cart_seats_by_user seat_owner
      end
    end

    private

    def cart_items_for_shop
      Cart.for_shop(@item.workshop_id)
    end

    def seat_owner
      @seat_owner ||= @item.gifted? && @item.owner.email ? new_user_from_guest : @current_user
    end

    def new_user_from_guest
      User.find_or_initialize_by(email: @item.owner.email)
    end

    def check_cart_seats_by_first_and_last_name
      cart_items_for_shop.any? do |cart|
        SeatService::Matcher.match(cart, @item)
      end
    end

    def check_cart_seats_by_user(user)
      cart_items_for_shop.non_gift_seat.for(user).any?
    end
  end
end
