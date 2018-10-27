# frozen_string_literal: true

module Ares
  # Handles communication with the Braintree API for processing card and PayPal payments.
  class OrderService
    attr_reader :order

    def initialize(order)
      @order = order
    end

    # marks the order as canceled and notifies the customer
    def cancel
      @order.date_canceled = Time.now
      was_successful = @order.save!
      OrderMailer.with(order: @order).canceled.deliver_now if was_successful && @order.placed?
      was_successful
    end

    # marks the order as closed
    def close
      @order.date_closed = Time.now
      @order.save!
    end

    # creates and places the order by removing the requested products from inventory
    def place(payment_nonce)
      return false unless @order.valid?

      ActiveRecord::Base.transaction do
        if initial_save_reload! &&
           process_payment(payment_nonce) &&
           remove_items_from_inventory_and_cart &&
           order_ready?
          mark_order_success
          return true
        else
          raise ActiveRecord::Rollback
        end
      end
      false
    end

    private

    def build_items(user, as_of_date)
      value = []
      CartItem.for(user).as_of(as_of_date).each do |cart_item|
        value << OrderItem.create(cart_item.event, cart_item.quantity)
      end
      value
    end

    def mark_order_success
      @order.date_placed = Time.now
      @order.date_fulfilled = Time.now
      if @order.save
        OrderMailer.with(order: @order).placed.deliver_now
        true
      else
        false
      end
    end

    def order_ready?
      @order.paid_in_full? && @order.valid?
    end

    def process_payment(payment_nonce)
      service = Ares::PaymentService.new(@order)
      return false unless service.process(payment_nonce)

      @order.payments << service.payment
      true
    end

    def initial_save_reload!
      @order.save!
      @order.reload
    end

    def remove_items_from_inventory_and_cart
      @order.items.each do |item|
        item.event.remove_stock(item.quantity)
      end
      CartItem.for(@order.customer).as_of(@order.date_created).delete_all
      true
    end
  end
end
