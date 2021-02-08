# frozen_string_literal: true

module GiftCardService
  class Booker
    def initialize(invoice_item, current_user)
      @item = invoice_item
      @current_user = current_user
    end

    def self.perform(invoice_item, current_user)
      new(invoice_item, current_user).perform
    end

    def perform
      recipient = User.find_or_invite(@item.owner.first_name, @item.owner.last_name, @item.owner.email)
      recipient.credits << CustomerCredit.new(starting_amount: @item.item_amount, balance: @item.item_amount)
      recipient.save!
    end
  end
end
