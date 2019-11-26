# frozen_string_literal: true

module Workshopable
  extend ActiveSupport::Concern

  def single_seats_allowed?
    if overridden_single_seat_allow.nil?
      workshop_type.default_single_seat_allow
    else
      overridden_single_seat_allow
    end
  end

  def reservations_allowed?
    if overridden_reservation_allow.nil?
      workshop_type.default_reservation_allow
    else
      overridden_reservation_allow
    end
  end

  def reservations_void_minimum_not_met?
    if overridden_reservation_cancel_minimum_not_met.nil?
      workshop_type.default_reservation_cancel_minimum_not_met
    else
      overridden_reservation_cancel_minimum_not_met
    end
  end

  def multiple_reservations_allowed?
    if overridden_reservation_allow_multiple.nil?
      workshop_type.default_reservation_allow_multiple
    else
      overridden_reservation_allow_multiple
    end
  end

  def reservation_minimum_seats
    if overridden_reservation_minimum.nil?
      workshop_type.default_reservation_minimum
    else
      overridden_reservation_minimum
    end
  end

  def reservation_maximum_seats
    reservation_maximum = if overridden_reservation_maximum.nil?
                            workshop_type.default_reservation_maximum
                          else
                            overridden_reservation_maximum
                          end

    reservation_maximum > total_seats ? total_seats : reservation_maximum
  end

  def reservation_allow_guest_cancel_seat?
    if overridden_reservation_allow_guest_cancel_seat.nil?
      workshop_type.default_reservation_allow_guest_cancel_seat
    else
      overridden_reservation_allow_guest_cancel_seat
    end
  end

  def reservation_price
    if overridden_reservation_price.nil?
      workshop_type.default_reservation_price
    else
      overridden_reservation_price
    end
  end

  def total_seats
    if overridden_total_seats.nil?
      workshop_type.default_total_seats
    else
      overridden_total_seats
    end
  end

  def seats_available
    total_seats - seats.select(&:active?).count
  end

  def seating_availability
    (seats_available.to_f / total_seats.to_f) * 100
  end

  def when
    start_date.strftime("%a, %B #{start_date.day.ordinalize}, %-l:%M%p")
  end

  def when_purchase
    date_out(purchase_start_date, purchase_end_date)
  end

  def booking_deadline
    start_date.beginning_of_day - 8.days
  end

  def registration_deadline
    start_date.beginning_of_day - 7.days
  end
end
