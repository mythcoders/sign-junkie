# frozen_string_literal: true

module Voidable
  extend ActiveSupport::Concern

  # if the reservation is able to be voided by the system
  def voidable?
    return false if refunded? || canceled? || voided? || Time.zone.now < workshop.registration_deadline
    return true if reservation? && !reservation.requirements_met? &&
                   (workshop.reservations_void_minimum_not_met? || reservation.active_seats.count.zero?)

    false
  end

  def voided?
    void_date.present?
  end
end
