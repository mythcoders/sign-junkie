# frozen_string_literal: true

# Enforces the _PaymentDeadline_ for +Workshop+ +Reservations+.
# Kicks off a +SeatVoidWorker+ for every +Seat+ that hasn't been paid for.
class PaymentDeadlineWorker
  include Sidekiq::Worker

  def perform
    reservations.each do |reservation|
      Rails.logger.debug "PaymentDeadlineWorker#perform - #{reservation.id}"

      batch = schedule_batch(reservation)
      if batch.total.positive?
        Rails.logger.debug "PaymentDeadlineWorker started batch #{batch.bid}"
      else
        on_success(batch, 'reservation_id' => reservation.id)
      end
    end
  end

  def on_success(status, options)
    Rails.logger.debug "PaymentDeadlineWorker#on_success - #{options['reservation_id']}"
    Rails.logger.warning 'Sidekiq batch has failures' if status.failures != 0

    reservation = Reservation.find(options['reservation_id'])
    return unless reservation.voidable?

    Rails.logger.debug "checked reservation #{reservation.id} - ReservationVoidWorker"
    ReservationVoidWorker.perform_async(reservation.id)
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

  def schedule_batch(reservation)
    batch = Sidekiq::Batch.new
    batch.description = "PaymentDeadline for #{reservation.id}"
    batch.on(:success, PaymentDeadlineWorker, reservation_id: reservation.id)
    batch.jobs do
      reservation.active_seats.select(&:active?).each do |seat|
        SeatVoidWorker.perform_async(seat.id) if seat.unpaid?
      end
    end

    Sidekiq::Batch::Status.new(batch.bid)
  end
end
