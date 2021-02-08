# frozen_string_literal: true

module ReservationService
  class Cancel
    def initialize(reservation)
      @reservation = reservation
    end

    def self.perform(reservation)
      new(reservation).perform
    end

    def perform
      return true if @reservation.canceled? || @reservation.voided?

      @reservation.seats.select(&:active?).each do |seat|
        SeatService::Cancel.perform(seat)
      end

      @reservation.cancel_date = Time.zone.now
      @reservation.save!
    end
  end
end
