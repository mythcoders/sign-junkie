# frozen_string_literal: true

module SeatService
  class Void
    def initialize(seat)
      @seat = seat
    end

    def self.perform(seat)
      new(seat).perform
    end

    def perform
      @seat.void_date = Time.zone.now
      return false unless @seat.valid? && @seat.save!

      RefundWorker.perform_async(@seat.item_description_id) if @seat.refundable?
      true
    end
  end
end
