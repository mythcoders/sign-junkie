# frozen_string_literal: true

module InvoiceService
  class Factory
    def initialize(user, pay_with_gift_card, created_at)
      @user = user
      @paying_with_gift_card = ActiveModel::Type::Boolean.new.cast pay_with_gift_card
      @created_at = created_at
    end

    def self.build(user, pay_with_gift_card, created_at)
      new(user, pay_with_gift_card, created_at).perform
    end

    def perform
      @invoice = new_invoice

      Cart.for(@user).as_of(@invoice.created_at).each do |cart_item|
        @invoice.items << InvoiceItem.new(item_description_id: cart_item.item_description_id)
      end

      @invoice.payments << new_gift_card_payment if can_pay_with_gift_card?
      @invoice
    end

    private

    def new_invoice
      Invoice.new(user_id: @user.id,
                  status: :draft,
                  due_date: Time.zone.today,
                  created_at: @created_at)
    end

    def new_gift_card_payment
      Payment.new(method: 'gift_card',
                  amount: [@invoice.grand_total, @user.credit_balance].min)
    end

    def can_pay_with_gift_card?
      @paying_with_gift_card && @user.credit_balance.positive?
    end
  end
end
