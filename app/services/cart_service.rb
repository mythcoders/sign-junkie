# frozen_string_literal: true

##
# Handles complex operations for the Cart model
class CartService < ApplicationService
  GENERAL_PARAMS = %i[workshop_id seat_id reservation_id type].freeze
  GIFT_CARD_PARAMS = %i[amount].freeze
  RESERVATION_PARAMS = %i[payment_plan].freeze
  GUEST_PARAMS = %i[guest_type first_name last_name email child_first_name child_last_name seat_request].freeze
  SEAT_PARAMS = %i[project_id addon_id stencils].freeze

  def self.permitted_params
    GENERAL_PARAMS + GIFT_CARD_PARAMS + GUEST_PARAMS + SEAT_PARAMS + RESERVATION_PARAMS
  end

  # Adds a new item to the users cart
  #
  # @return [Boolean] result of +.save+
  def add(user, cart_params)
    return pay_for_reservation(user, cart_params) if cart_params[:reservation_id]
    return pay_for_seat(user, cart_params) if cart_params[:seat_id]

    cart = if cart_params[:type] == 'gift_card'
             new_gift_card(user, cart_params)
           else
             add_item user, cart_params
           end
    cart.save
  end

  # Adds the requested seat to the users cart
  #
  # @return [Boolean] result of +.save+
  def pay_for_seat(user, cart_params)
    seat = Seat.find cart_params[:seat_id]

    new_from_seat(user, seat).save
  end

  # Adds all unpaid seats for the requested reservation to the users cart
  #
  # @return [Boolean]
  def pay_for_reservation(user, cart_params)
    reservation = Reservation.find cart_params[:reservation_id]

    reservation.unpaid_seats.each do |seat|
      new_from_seat(user, seat).save
    rescue StandardError => e
      Raven.capture_exception e
    end
  end

  def remove(user, cart_params)
    cart = Cart.find(cart_params[:id])
    return false if user.id != cart.user_id

    cart.delete
  end

  def empty!(user, as_of = Time.zone.now)
    Cart.for(user).as_of(as_of).delete_all
  end

  private

  def add_item(user, cart_params)
    workshop = Workshop.includes(:projects).find(cart_params[:workshop_id])

    if cart_params[:type] == 'reservation'
      raise ProcessError, 'Workshop is not available for purchase' unless workshop.reservation_purchaseable?

      new_reservation user, workshop, cart_params
    else
      raise ProcessError, 'Workshop is not available for purchase' unless workshop.seat_purchaseable?
      raise ProcessError, 'No project selected' unless cart_params[:project_id].present?

      new_seat user, workshop, cart_params
    end
  end

  def new_seat(user, workshop, params)
    Cart.new(user: user,
             description: SeatItemFactory.build(workshop, params))
  end

  def new_gift_card(user, params)
    Cart.new(user: user,
             description: ItemDescription.gift_card(params),
             nontaxable_amount: params[:amount],
             taxable_amount: 0.00)
  end

  def new_reservation(user, workshop, params)
    Cart.new(user: user,
             description: ItemDescription.reservation(workshop),
             payment_plan: params[:payment_plan],
             nontaxable_amount: workshop.reservation_price,
             taxable_amount: 0.00)
  end

  def new_from_seat(user, seat)
    Cart.new(user: user,
             item_description_id: seat.item_description_id)
  end
end
