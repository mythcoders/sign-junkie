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

  def self.process(user, cart_params)
    new(user, cart_params).build
  end

  def self.permitted_params
    GENERAL_PARAMS + GIFT_CARD_PARAMS + GUEST_PARAMS + SEAT_PARAMS + RESERVATION_PARAMS
  end

  def build
    if @params[:reservation_id]
      add_reservation
    elsif @params[:seat_id]
      add_seat
    elsif @params[:type] == 'gift_card'
      Cart.create!(user: @current_user, description: GiftCardService::ItemFactory.build(@params))
    elsif @params[:type] == 'reservation'
      Cart.create!(user: @current_user, description: ReservationService::ItemFactory.build(workshop, @params))
    else
      Cart.create!(user: @current_user, description: SeatService::ItemFactory.build(workshop, @params))
    end
  end

  private

  def workshop
    @workshop ||= Workshop.find(@params[:workshop_id])
  end

  def add_reservation(user, cart_params)
    reservation = Reservation.find @params[:reservation_id]

    reservation.unpaid_seats.each do |seat|
      Cart.create!(user: @current_user, item_description_id: seat.item_description_id)
    rescue StandardError => e
      Sentry.capture_exception e
    end
  end

  def add_seat
    seat = Seat.find @params[:seat_id]
    Cart.create!(user: @current_user, item_description_id: seat.item_description_id)
  end
end