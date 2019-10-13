# frozen_string_literal: true

module Workshopable
  extend ActiveSupport::Concern

  def single_seats_allowed?
    overridden_single_seat_allow || workshop_type.default_single_seat_allow
  end

  def reservations_allowed?
    overridden_reservation_allow || workshop_type.default_reservation_allow
  end

  def reservations_void_minimum_not_met?
    overridden_reservation_cancel_minimum_not_met || workshop_type.default_reservation_cancel_minimum_not_met
  end

  def multiple_reservations_allowed?
    overridden_reservation_allow_multiple || workshop_type.default_reservation_allow_multiple
  end

  def reservation_minimum_seats
    overridden_reservation_minimum || workshop_type.default_reservation_minimum
  end

  def reservation_maximum_seats
    reservation_maximum = overridden_reservation_maximum || workshop_type.default_reservation_maximum
    reservation_maximum > total_seats ? total_seats : reservation_maximum
  end

  def reservation_allow_guest_cancel_seat
    overridden_reservation_allow_guest_cancel_seat || workshop_type.default_reservation_allow_guest_cancel_seat
  end

  def reservation_price
    overridden_reservation_price || workshop_type.default_reservation_price
  end

  def total_seats
    overridden_total_seats || workshop_type.default_total_seats
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
