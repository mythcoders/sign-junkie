# frozen_string_literal: true

class ReservationVoidWorker
  include Sidekiq::Worker

  def perform(reservation_id)
    reservation = Reservation.find reservation_id
    return if reservation.voided?

    Rails.logger.info "ReservationVoidWorker #{reservation_id}"
    ReservationService.new.void(reservation)
    ReservationMailer.with(reservation_id: reservation.id).voided.deliver_later
    Appsignal.increment_counter('seats.voided', 1)
  end
end
