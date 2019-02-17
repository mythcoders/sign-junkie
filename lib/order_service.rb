# frozen_string_literal: true

# Handles communication with the Braintree API for processing card and PayPal payments.
class OrderService
  attr_reader :order, :user

  def initialize(order, user)
    @order = order
    @user = user
  end

  # marks the order as canceled and notifies the customer
  def cancel
    @order.date_canceled = Time.now
    # todo: issue refund
    was_successful = @order.save!
    OrderMailer.with(order: @order).canceled.deliver_now if was_successful && @order.placed?
    was_successful
  end

  # creates and places the order by removing the requested products from inventory
  def place(payment)
    ActiveRecord::Base.transaction do
      if initial_save_reload! &&
          process_payment(payment) &&
          empty_cart &&
          order_ready?
        mark_placed_and_notify(payment)
        return true
      else
        Rails.logger.warn 'order place failed!'
        raise ActiveRecord::Rollback
      end
    end
    false
  end

  private

  def mark_placed_and_notify(payment)
    @order.placed!
    @order.date_placed = Time.now
    if payment.save! && @order.save!
      OrderMailer.with(payment: payment).placed.deliver_now
      true
    else
      false
    end
  end

  def order_ready?
    @order.valid?
  end

  def process_payment(payment)
    service = PaymentService.new(payment)
    return false unless service.process

    true
  end

  def initial_save_reload!
    @order.save!
    @order.reload
  end

  def empty_cart
    CartItem.for(@user).as_of(@order.created_at).delete_all
    true
  end
end
