# frozen_string_literal: true

class ReservationService < ApplicationService
  class << self
    def already_booked?(user, workshop_id)
      Reservation.for_user(user).for_shop(workshop_id).active.any?
    end
  end

  def book(invoice_item, host)
    reservation = Reservation.new(
      item_description_id: invoice_item.description.id,
      workshop_id: invoice_item.workshop_id,
      user_id: host.id
    )

    reservation.save!
  end

  def cancel(reservation)
    return true if reservation.canceled? || reservation.voided?

    reservation.seats.select(&:active?).each do |seat|
      SeatService.new.cancel(seat)
    end
    reservation.cancel_date = Time.zone.now
    reservation.save!
  end

  def void(reservation)
    return true if reservation.voided? || reservation.canceled?

    reservation.seats.select(&:active?).each do |seat|
      SeatService.new.void(seat)
    end
    reservation.void_date = Time.zone.now
    reservation.save!
  end
end
