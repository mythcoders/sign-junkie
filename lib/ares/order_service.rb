module Ares
  class OrderService

    attr_reader :order

    def initialize(order)
      @order = order
    end

    # created and places the order by removing the requested products from inventory
    def place(payment_nonce)
      return false unless @order.valid?

      ActiveRecord::Base.transaction do
        initial_save_reload
        if process_payment(payment_nonce) &&
           remove_items_from_inventory &&
           remove_items_from_cart &&
           order_ready
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

    def order_ready
      @order.paid_in_full? && @order.valid?
    end

    def process_payment(payment_nonce)
      service = Ares::PaymentService.new(@order)
      return false unless service.process(payment_nonce)

      @order.payments << service.payment
      true
    end

    def initial_save_reload
      @order.save!
      @order.reload
    end

    def remove_items_from_inventory
      @order.items.each do |item|
        item.event.remove_stock(item.quantity)
      end
      true
    end

    def remove_items_from_cart
      CartItem.for(@order.customer).as_of(@order.date_created).delete_all
      true
    end
  end
end
