# frozen_string_literal: true

module InvoiceService
  class Factory
    def initialize(user, pay_with_gift_card, created_at)
      @user = user
      @paying_with_gift_card = pay_with_gift_card
      @created_at = created_at
    end

    def self.build(user, pay_with_gift_card, created_at = Time.zone.now)
      new(user, pay_with_gift_card, created_at).perform
    end

    def perform
      @invoice = Invoice.new(user_id: @user.id,
                             status: :draft,
                             due_date: Time.zone.today,
                             created_at: @created_at)

      Cart.for(@user).as_of(@invoice.created_at).each do |cart_item|
        @invoice.items << InvoiceItem.new(item_description_id: cart_item.item_description_id)
      end

      @invoice.payments << new_gift_card_payment if @paying_with_gift_card == 'true' && @user.credit_balance.positive?
      @invoice
    end

    private

    def new_gift_card_payment
      if @invoice.grand_total <= @user.credit_balance
        Payment.new(amount: @invoice.grand_total, method: 'gift_card')
      else
        Payment.new(amount: @user.credit_balance, method: 'gift_card')
      end
    end
  end
end
