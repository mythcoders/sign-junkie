# frozen_string_literal: true

module SeatService
  # called when creating or updating a seat on a reservation
  class Updater
    NON_UPDATEABLE_ATTRIBUTES = %w[id identifier created_at updated_at refund_date cancel_date void_date workshop_id
                                   workshop_name].freeze

    def initialize(seat, current_user, params)
      @seat = seat
      @current_user = current_user
      @raw_params = SeatService::ParamParser.perform(params, current_user)
    end

    def self.perform(seat, current_user, params)
      new(seat, current_user, params).perform
    end

    def perform
      if @seat.description.nil?
        set_new_description
      else
        update_existing_description
      end

      set_customer
      return false unless @seat.valid? && @seat.save!

      notify_guest_if_applicable

      true
    end

    private

    def set_new_description
      @seat.description = built_description
    end

    def update_existing_description
      @seat.description.assign_attributes built_description_attributes
    end

    def set_customer
      @seat.customer = SeatService::CalculateCustomer.perform(@seat, @current_user)
    end

    def notify_guest_if_applicable
      notify_guest if @seat.owner.type == 'adult' && !@seat.selection_made? && !@seat.persisted?
    end

    def notify_guest
      SeatMailer.with(seat_id: @seat.id).invited.deliver_later
    end

    def built_description
      @built_description ||= SeatService::ItemFactory.build(@seat.workshop, @raw_params)
    end

    def built_description_attributes
      built_description.attributes.reject { |key, _| NON_UPDATEABLE_ATTRIBUTES.include? key }
    end
  end
end
