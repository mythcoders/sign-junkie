# frozen_string_literal: true

class SeatCancelWorker
  include Sidekiq::Worker

  def perform(seat_id)
    seat = Seat.find seat_id
    return if seat.canceled?

    SeatService.new.cancel(seat)
    SeatMailer.with(seat: seat).canceled.deliver_later
  end
end
