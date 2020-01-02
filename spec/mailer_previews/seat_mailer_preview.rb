# frozen_string_literal: true

class SeatMailerPreview < ActionMailer::Preview
  def remind
    SeatMailer.with(seat_id: Seat.first.id).remind
  end

  def voided
    SeatMailer.with(seat_id: Seat.first.id).voided
  end

  def invited
    SeatMailer.with(seat_id: Seat.first.id).invited
  end

  def canceled
    SeatMailer.with(seat_id: Seat.first.id).canceled
  end

  def ready_for_payment
    SeatMailer.with(seat_id: Seat.first.id).ready_for_payment
  end
end
