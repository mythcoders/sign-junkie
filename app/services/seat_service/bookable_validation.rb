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
      validate_not_booking_adult_seat_with_own_email unless @item.persisted?
      validate_workshop_accepting_seats unless @item.persisted?
      validate_not_already_in_cart
      validate_not_already_booked

      true
    end

    private

    def validate_not_booking_adult_seat_with_own_email
      raise ProcessError, I18n.translate("workshop.booking_adult_own_email") if booking_adult_seat_with_own_email?
    end

    def validate_workshop_accepting_seats
      raise ProcessError, I18n.translate("workshop.seats_full") unless @item.workshop.seat_purchaseable?
    end

    def validate_not_already_in_cart
      raise ProcessError, I18n.translate("seat.already_in_cart") if @item.in_cart?
    end

    def validate_not_already_booked
      raise ProcessError, I18n.translate("seat.already_booked") if already_booked_seats? || similar_cart_items?
    end

    def similar_cart_items?
      CartService::SimilarSeat.check(@item, @current_user)
    end

    def already_booked_seats?
      return false if @item.workshop.workshop_type.multiple_seats?

      case @item.guest_type
      when "other", "child"
        check_paid_seats_by_first_and_last_name
      else
        check_paid_seats_by_user seat_owner
      end
    end

    def seat_owner
      @seat_owner ||= @item.gifted? && @item.owner.email ? new_user_from_guest : @current_user
    end

    def new_user_from_guest
      User.find_or_initialize_by(email: @item.owner.email.downcase)
    end

    def current_active_seats
      @current_active_seats ||= Seat.for_shop(@item.workshop_id).active
    end

    def check_paid_seats_by_user(user)
      current_active_seats.for_user(user).not_gifted.select(&:paid?).any?
    end

    def check_paid_seats_by_first_and_last_name
      current_active_seats.select(&:paid?).any? do |seat|
        SeatService::Matcher.match(seat, @item)
      end
    end

    def booking_adult_seat_with_own_email?
      return false unless @item.guest_type == "adult"

      @item.owner.email == @current_user.email
    end
  end
end
