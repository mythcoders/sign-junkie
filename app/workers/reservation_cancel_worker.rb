# frozen_string_literal: true

class ReservationCancelWorker
  include Sidekiq::Worker

  def perform(reservation_id)
    reservation = Reservation.find reservation_id
    return if reservation.canceled?

    ReservationService.new.cancel(reservation)
    ReservationMailer.with(reservation_id: reservation.id).canceled.deliver_later
    # Appsignal.increment_counter('reservations.cancelled', 1)
    RefundWorker.perform_async(reservation.item_description_id) if reservation.refundable?
  end
end
