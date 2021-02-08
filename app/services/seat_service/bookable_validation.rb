# frozen_string_literal: true

module SeatService
  # attempting to add a seat to their cart
  class BookableValidation
    def initialize(cart_description, current_user)
      @item = cart_description
      @current_user = current_user
    end

    def self.perform(cart_description, current_user)
      new(cart_description, current_user).perform
    end

    def perform
      validate_workshop_accepting_seats unless @item.persisted?
      validate_not_already_in_cart
      validate_not_already_booked
    end

    private

    def validate_workshop_accepting_seats
      raise ProcessError, I18n.translate('workshop.seats_full') unless @item.workshop.seat_purchaseable?
    end

    def validate_not_already_in_cart
      raise ProcessError, I18n.translate('seat.already_in_cart') if @item.in_cart?
    end

    def validate_not_already_booked
      raise ProcessError, I18n.translate('seat.already_booked') if already_booked_seats? || similar_cart_items?
    end

    def similar_cart_items?
      if @item.gifted_seat?
        query = if @item.owner.email.present?
                  { email: @item.owner.email }
                else
                  { first_name: @item.owner.first_name, last_name: @item.owner.last_name }
                end

        Cart.for_shop(@item.workshop_id).seats.where('item_descriptions.owner @> ?', query.to_json).any?
      else
        Cart.for_shop(@item.workshop_id).non_gift_seat.for(seat_owner).any?
      end
    end

    def already_booked_seats?
      active_seats = Seat.for_shop(@item.workshop_id).active

      if @item.gifted_seat? && @item.owner.email.present?
        active_seats.for_user(@item.recipient).select(&:paid?).any?
      elsif @item.gifted_seat?
        active_seats.select(&:paid?).any? do |a|
          a.owner.first_name == @item.owner.first_name && a.owner.last_name == @item.owner.last_name
        end
      else
        active_seats.for_user(seat_owner).select(&:paid?).any?
      end
    end

    def seat_owner
      @seat_owner ||= @item.gifted? && @item.owner.email ? new_user_from_guest : @current_user
    end

    def existing_reservation
      @existing_reservation ||= Reservation.already_booked?(seat_owner, @item.workshop_id)
    end

    def new_user_from_guest
      User.find_or_initialize_by(email: @item.owner.email)
    end
  end
end
