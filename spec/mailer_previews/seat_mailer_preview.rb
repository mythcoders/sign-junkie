# frozen_string_literal: true

class SeatMailerPreview < ActionMailer::Preview
  def remind
    SeatMailer.with(seat: Seat.first).remind
  end

  def voided
    SeatMailer.with(seat: Seat.first).voided
  end

  def invited
    SeatMailer.with(seat: Seat.first).invited
  end

  def canceled
    SeatMailer.with(seat: Seat.first).canceled
  end

  def ready_for_payment
    SeatMailer.with(seat: Seat.first).ready_for_payment
  end
end
