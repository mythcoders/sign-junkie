# frozen_string_literal: true

module ReservationService
  class Void
    def initialize(reservation)
      @reservation = reservation
    end

    def self.perform(reservation)
      new(reservation).perform
    end

    def perform
      return true if @reservation.voided? || @reservation.canceled?

      @reservation.seats.select(&:active?).each do |seat|
        SeatService::Void.perform(seat)
      end

      @reservation.void_date = Time.zone.now
      @reservation.save!
    end
  end
end
