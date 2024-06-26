# frozen_string_literal: true

class SeatVoidWorker
  include Sidekiq::Worker

  def perform(seat_id)
    seat = Seat.find seat_id
    return if seat.voided?

    Rails.logger.info "SeatVoidWorker #{seat_id}"
    SeatService::Void.perform(seat)
    SeatMailer.with(seat_id: seat.id).voided.deliver_later
  end
end
