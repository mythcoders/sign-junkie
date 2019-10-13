# frozen_string_literal: true

class ReservationMailerPreview < ActionMailer::Preview
  def ready_for_payment
    ReservationMailer.with(reservation: Reservation.first).ready_for_payment
  end

  def voided
    ReservationMailer.with(reservation: Reservation.first).voided
  end

  def placed
    ReservationMailer.with(reservation: Reservation.first).placed
  end

  def canceled
    ReservationMailer.with(reservation: Reservation.first).canceled
  end
end
