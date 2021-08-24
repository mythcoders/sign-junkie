# frozen_string_literal: true

module SeatService
  # Handles associating a seat to the correct customers account
  # Invites the customer if they already don't have an account
  class CalculateCustomer
    def initialize(invoice_item, current_user)
      @item = invoice_item
      @current_user = current_user
    end

    def self.perform(invoice_item, current_user)
      new(invoice_item, current_user).perform
    end

    def perform
      case @item.guest_type
      when "child"
        find_or_invite_user @item.owner.parent
      when "adult"
        find_or_invite_user @item.owner
      else
        @current_user
      end
    end

    def find_or_invite_user(user)
      User.find_or_invite(user.first_name, user.last_name, user.email)
    end
  end
end
