# frozen_string_literal: true

# Enforces the _PaymentDeadline_ for +Workshop+ +Reservations+.
# Kicks off a +SeatVoidWorker+ for every +Seat+ that hasn't been paid for.
class PaymentDeadlineWorker
  include Sidekiq::Worker

  def perform
    reservations.each do |reservation|
      Rails.logger.debug "PaymentDeadlineWorker#perform - #{reservation.id}"

      reservation.active_seats.select(&:active?).each do |seat|
        SeatVoidWorker.perform_async(seat.id) if seat.unpaid?
      end

      next if reservation.active_seats.select(&:active?).any?(&:paid?)
      ReservationVoidWorker.perform_async(reservation.id)
    end
  end

  private

  def reservations(as_of = Time.zone.yesterday)
    reservations_paid_by_guest(as_of) + reservations_paid_by_host(as_of)
  end

  def reservations_paid_by_guest(as_of)
    Reservation.active.paid_by_guest
      .joins(:workshop)
      .where("date_trunc('day', workshops.start_date - interval '7 days') = date_trunc('day', ?::date)", as_of)
  end

  def reservations_paid_by_host(as_of)
    Reservation.active.paid_by_host
      .joins(:workshop)
      .where("date_trunc('day', workshops.start_date - interval '5 days') = date_trunc('day', ?::date)", as_of)
  end
end
