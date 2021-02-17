# frozen_string_literal: true

module CartService
  # attempting to add a seat to their cart
  class SimilarReservation
    def initialize(cart_item, current_user)
      @item = cart_item
      @current_user = current_user
    end

    def self.check(cart_item, current_user)
      new(cart_item, current_user).similar_cart_items?
    end

    def similar_cart_items?
      Cart.for(@current_user).for_shop(@item.workshop_id).reservations.any?
    end
  end
end
