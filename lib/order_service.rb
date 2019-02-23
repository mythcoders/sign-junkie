# frozen_string_literal: true

# Workflow
class OrderService
  attr_reader :order, :user

  def initialize(order, user)
    @order = order
    @user = user
  end

  # marks the order as canceled and notifies the customer
  def cancel(params)
    return false if cancel_params_valid?(params)

    ids = params.split(',')
    order_items = @order.items.select { |i| ids.includes?(i.id) }

    ActiveRecord::Base.transaction do
      order_items.each do |order_item|
        cancel_item order_item
      end
      process_refund order_items
    end

    true
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

  def cancel_item(item)
    if !item.paid? && item.unassigned?
      item.delete
    elsif item.assigned?
      # email email
    end
    # send emaili
  end

  def process_refund(items)
    return true

    refund = Refund.build(items)
    PaymentService.new(refund).refund
  end

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
