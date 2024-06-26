# frozen_string_literal: true

module SeatService
  # Create seat in the context of processing the invoice
  class Booker
    def initialize(invoice_item, current_user)
      @item = invoice_item
      @current_user = current_user
    end

    def self.perform(invoice_item, current_user)
      new(invoice_item, current_user).perform
    end

    def perform
      return unless @item.description.seat.nil?

      Seat.create!(
        item_description_id: @item.description.id,
        workshop_id: @item.workshop_id,
        customer: customer
      )
    end

    private

    def customer
      SeatService::CalculateCustomer.perform(@item, @item.invoice.customer)
    end
  end
end
