# frozen_string_literal: true

# Sends a reminder to hosts that are at risk of violating the _PaymentDeadline_ for +Workshop+ +Reservations+.
class PaymentDeadlineReminderWorker
  include Sidekiq::Worker

  def perform
    reservations.each do |reservation|
      next unless reservation.unpaid_seats.any?

      ReservationMailer.with(reservation_id: reservation.id).payment_deadline.deliver_later
    end
  end

  private

  def reservations(as_of = Time.zone.today)
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
