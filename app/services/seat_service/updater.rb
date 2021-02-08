# frozen_string_literal: true

module SeatService
  # called when updating a seat on a reservation
  class Updater
    def initialize(seat, current_user, params)
      @seat = seat
      @current_user = current_user
      @raw_params = params
    end

    def self.perform(seat, current_user, params)
      new(seat, current_user, params).perform
    end

    def perform
      @seat.description = SeatService::ItemFactory.build(@seat.workshop, @raw_params)
      @seat.customer = SeatService::CalculateOwner.perform(@seat, @current_user) unless @seat.customer
      return false unless @seat.valid? && @seat.save!

      notify_guest if @seat.owner.type == 'adult' && !@seat.selection_made? && !@seat.persisted?

      true
    end

    private

    def params
      @params ||= Hashie::Mash.new(@raw_params)
    end

    def notify_guest
      SeatMailer.with(seat_id: @seat.id).invited.deliver_later
    end
  end
end
