# frozen_string_literal: true

class ReservationVoidWorker
  include Sidekiq::Worker

  def perform(reservation_id)
    reservation = Reservation.find reservation_id
    return if reservation.voided?

    ReservationService::Void.perform(reservation)
    ReservationMailer.with(reservation_id: reservation.id).voided.deliver_later
  end
end
