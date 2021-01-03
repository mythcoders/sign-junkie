# frozen_string_literal: true

module SeatService

  # Create seat in the context of processing the invoice
  class CalculateOwner
    def initialize(invoice_item, current_user)
      @item = invoice_item
      @current_user = current_user
    end

    def self.perform(invoice_item, current_user)
      new(invoice_item, current_user).perform
    end

    def perform
      if @item.gifted? && @item.owner.email.present?
        User.find_or_invite(@item.owner.first_name, @item.owner.last_name, @item.owner.email)
      else
        @current_user
      end
    end
  end
end