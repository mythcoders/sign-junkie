# frozen_string_literal: true

module CartSidebar
  class Component < ViewComponent::Base
    def initialize(items, gift_card_balance)
      @cart_items = items
      @credit_balance = gift_card_balance
    end

    def size
      @size ||= @cart_items.count
    end

    def total
      @total ||= subtotal + tax
    end

    def subtotal
      @subtotal ||= sum_and_round @cart_items.map(&:item_amount)
    end

    def tax
      @tax ||= if @cart_items.select(&:taxable?).any?
        sum_and_round @cart_items.select(&:taxable?).map(&:tax_amount)
      else
        0.00
      end
    end

    private

    def sum_and_round(items)
      (items.reduce(:+) || 0.00).round(2)
    end
  end
end
