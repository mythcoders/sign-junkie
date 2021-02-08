# frozen_string_literal: true

class CartFactory
  GENERAL_PARAMS = %i[workshop_id seat_id reservation_id type].freeze
  GIFT_CARD_PARAMS = %i[amount].freeze
  RESERVATION_PARAMS = %i[payment_plan].freeze
  GUEST_PARAMS = %i[guest_type first_name last_name email child_first_name child_last_name seat_request].freeze
  SEAT_PARAMS = %i[project_id addon_id stencils].freeze

  def initialize(user, cart_params)
    @current_user = user
    @params = cart_params
  end

  def self.permitted_params
    GENERAL_PARAMS + GIFT_CARD_PARAMS + GUEST_PARAMS + SEAT_PARAMS + RESERVATION_PARAMS
  end

  def self.process!(user, cart_params)
    new(user, cart_params).process!
  end

  def process!
    if @params[:reservation_id]
      add_unpaid_reservation_seats
    elsif @params[:seat_id]
      add_existing_seat
    elsif @params[:type] == 'gift_card'
      add_gift_card
    elsif @params[:type] == 'reservation'
      add_reservation
    else
      add_seat
    end
  end

  private

  def workshop
    @workshop ||= Workshop.find @params[:workshop_id]
  end

  def add_unpaid_reservation_seats
    reservation = Reservation.find @params[:reservation_id]

    reservation.unpaid_seats.each do |seat|
      Cart.create! user: @current_user, item_description_id: seat.item_description_id
    rescue StandardError => e
      Sentry.capture_exception e
    end
  end

  def add_existing_seat
    seat = Seat.find @params[:seat_id]
    Cart.create! user: @current_user, item_description_id: seat.item_description_id
  end

  def add_gift_card
    Cart.create! user: @current_user, description: GiftCardService::ItemFactory.build(@params)
  end

  def add_reservation
    Cart.create! user: @current_user, description: ReservationService::ItemFactory.build(workshop, @params)
  end

  def add_seat
    Cart.create! user: @current_user, description: SeatService::ItemFactory.build(workshop, @params)
  end
end
