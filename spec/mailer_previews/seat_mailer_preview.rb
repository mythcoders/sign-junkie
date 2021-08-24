# frozen_string_literal: true

class SeatMailerPreview < ActionMailer::Preview
  def remind
    SeatMailer.with(seat_id: seat_with_reservation.id).remind
  end

  def voided
    SeatMailer.with(seat_id: seat.id).voided
  end

  def invited
    SeatMailer.with(seat_id: seat_with_reservation.id).invited
  end

  def canceled
    SeatMailer.with(seat_id: seat.id).canceled
  end

  def ready_for_payment
    SeatMailer.with(seat_id: seat_with_reservation.id).ready_for_payment
  end

  def registration_deadline
    SeatMailer.with(seat_id: seat_with_reservation.id).registration_deadline
  end

  def purchased
    SeatMailer.with(seat_id: guest_seat.id).purchased
  end

  private

  def seat
    @seat ||= Seat.first
  end

  def seat_with_reservation
    @seat_with_reservation ||= Seat.where("reservation_id IS NOT NULL").first
  end

  def guest_seat
    @guest_seat ||= Seat.joins(:description)
      .where("item_descriptions.email IS NOT NULL")
      .where("item_descriptions.item_type = ?", :seat)
      .first
  end
end
