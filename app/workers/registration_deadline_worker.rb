# frozen_string_literal: true

class RegistrationDeadlineWorker
  include Sidekiq::Worker

  def perform
    reservations.each do |reservation|
      Rails.logger.debug "RegistrationDeadlineWorker#perform - #{reservation.id}"

      # if batch didn't queue any jobs go ahead and trigger on_success
      # otherwise, let it trigger when the batch completes
      batch = create_void_seats_batch(reservation)
      status = Sidekiq::Batch::Status.new(batch.bid)
      if status.total.positive?
        Rails.logger.debug "RegistrationDeadlineWorker started batch #{batch.bid}"
      else
        on_success(status, 'reservation_id' => reservation.id)
      end
    end
  end

  def on_success(status, options)
    Rails.logger.debug "RegistrationDeadlineWorker#on_success - #{options['reservation_id']}"
    Rails.logger.warning 'Sidekiq batch has failures' if status.failures != 0

    reservation = Reservation.find(options['reservation_id'])
    if reservation.voidable?
      Rails.logger.debug "checked reservation #{reservation.id} - ReservationVoidWorker"
      ReservationVoidWorker.perform_async(reservation.id)
    elsif reservation.paid_by_host? && reservation.unpaid_balance?
      ReservationMailer.with(reservation: reservation).ready_for_payment.deliver_now
    else
      Rails.logger.debug "checked reservation #{reservation.id} - nothing"
    end
  end

  private

  def reservations(as_of = Time.zone.today)
    Reservation.active
               .joins(:workshop)
               .where("date_trunc('day', workshops.start_date - interval '7 days') = date_trunc('day', ?::date)", as_of)
  end

  def create_void_seats_batch(reservation)
    batch = Sidekiq::Batch.new
    batch.description = "RegistrationDeadline for #{reservation.id}"
    batch.on(:success, RegistrationDeadlineWorker, reservation_id: reservation.id)
    batch.jobs do
      reservation.seats.select(&:active?).each do |seat|
        SeatVoidWorker.perform_async(seat.id) unless seat.selection_made?
      end
    end
    batch
  end
end
