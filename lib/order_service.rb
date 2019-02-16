# frozen_string_literal: true

# Handles communication with the Braintree API for processing card and PayPal payments.
class OrderService
  attr_reader :order

  def initialize(order)
    @order = order
  end

  def self.tax_rate
    0.0725
  end

  def self.taxed?
    true
  end

  # marks the order as canceled and notifies the customer
  def cancel
    @order.date_canceled = Time.now
    # todo: issue refund
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
          empty_cart &&
          order_ready?
        mark_success
        mark_fulfilled
        return true
      else
        raise ActiveRecord::Rollback
      end
    end
    false
  end

  private

  def mark_success
    @order.date_placed = Time.now
    if @order.save
      OrderMailer.with(order: @order).placed.deliver_now
      true
    else
      false
    end
  end

  def mark_fulfilled
    return true unless fulfillable?

    @order.date_fulfilled = Time.now
    if @order.save
      true
    else
      false
    end
  end

  def fulfillable?
    @order.items.each do |item|
    end

    false
  end

  def order_ready?
    @order.valid?
  end

  def process_payment(payment_nonce)
    service = PaymentService.new(@order)
    return false unless service.process(payment_nonce)

    @order.payments << service.payment
    true
  end

  def initial_save_reload!
    @order.save!
    @order.reload
  end

  def empty_cart
    CartItem.for(@order.customer).as_of(@order.date_created).delete_all
    true
  end
end
