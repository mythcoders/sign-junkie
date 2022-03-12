# frozen_string_literal: true

class RegistrationDeadlineWorker
  include Sidekiq::Worker

  def perform
    reservations.each do |reservation|
      Rails.logger.debug "RegistrationDeadlineWorker#perform - #{reservation.id}"

      reservation.seats.select(&:active?).each do |seat|
        SeatVoidWorker.perform_async(seat.id) unless seat.selection_made?
      end

      void_reservation reservation
    end
  end

  private

  def reservations(as_of = Time.zone.yesterday)
    Reservation.active
      .joins(:workshop)
      .where("date_trunc('day', workshops.start_date - interval '7 days') = date_trunc('day', ?::date)", as_of)
  end

  def void_reservation(reservation)
    if reservation.voidable?
      Rails.logger.debug "checked reservation #{reservation.id} - ReservationVoidWorker"
      ReservationVoidWorker.perform_async(reservation.id)
    elsif reservation.paid_by_host? && reservation.unpaid_balance?
      ReservationMailer.with(reservation_id: reservation.id).ready_for_payment.deliver_later
    else
      Rails.logger.debug "checked reservation #{reservation.id} - nothing"
    end
  end
end
