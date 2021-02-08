module ReservationService
  class BookableValidation
    def initialize(cart, current_user)
      @item = cart
      @current_user = current_user
    end

    def self.perform(cart, current_user)
      new(cart, current_user).perform
    end

    def perform
      validate_workshop_accepting_reservations
      validate_not_already_in_cart
      validate_not_already_booked
    end

    private

    def validate_workshop_accepting_reservations
      raise ProcessError, I18n.translate('workshop.reservations_full') unless @item.workshop.reservation_purchaseable?
    end

    def validate_not_already_in_cart
      raise ProcessError, I18n.translate('reservations.already_in_cart') if @item.in_cart?
    end

    def validate_not_already_booked
      if already_booked_reservation? || similar_cart_items?
        raise ProcessError,
              I18n.translate('reservations.already_booked')
      end
    end

    def already_booked_reservation?
      @existing_reservation ||= Reservation.already_booked?(@current_user, @item.workshop_id)
    end

    def similar_cart_items?
      @existing_cart_items ||= Cart.for(@current_user).for_shop(@item.workshop_id).reservations.any?
    end
  end
end
