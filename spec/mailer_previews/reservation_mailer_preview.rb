# frozen_string_literal: true

class ReservationMailerPreview < ActionMailer::Preview
  def ready_for_payment
    ReservationMailer.with(reservation_id: Reservation.first.id).ready_for_payment
  end

  def voided
    ReservationMailer.with(reservation_id: Reservation.first.id).voided
  end

  def placed
    ReservationMailer.with(reservation_id: Reservation.first.id).placed
  end

  def canceled
    ReservationMailer.with(reservation_id: Reservation.first.id).canceled
  end

  def payment_deadline
    ReservationMailer.with(reservation_id: Reservation.first.id).payment_deadline
  end
end
