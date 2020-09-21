# frozen_string_literal: true

class SeatCancelWorker
  include Sidekiq::Worker

  def perform(seat_id)
    seat = Seat.find seat_id
    return if seat.canceled?

    SeatService.new.cancel(seat)
    SeatMailer.with(seat_id: seat.id).canceled.deliver_later
    # Appsignal.increment_counter('seats.cancelled', 1)
  end
end
