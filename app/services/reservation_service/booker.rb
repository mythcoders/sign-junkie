# frozen_string_literal: true

module ReservationService
  class Booker
    def initialize(invoice_item, current_user)
      @item = invoice_item
      @current_user = current_user
    end

    def self.perform(invoice_item, current_user)
      new(invoice_item, current_user).perform
    end

    def perform
      Reservation.create!(
        item_description_id: @item.description.id,
        workshop_id: @item.workshop_id,
        user_id: @current_user.id
      )
    end
  end
end
