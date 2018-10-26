# frozen_string_literal: true

class Order < ApplicationRecord
  include Taxable
  include Billable

  audited
  scope :current, ->(user_id) { where(user_id: user_id).order(:id) if user_id.present? }
  has_many :notes, class_name: 'OrderNote'

  # builds an order for the user based on the contents of their cart
  def self.build(user)
    order = Order.new(user_id: user.id, tax_rate: Ares::PaymentService.tax_rate, date_created: Time.now)
    CartItem.for(user).as_of(order.date_created).each do |cart_item|
      order.items << OrderItem.create(cart_item.event, cart_item.quantity)
    end
    order
  end

  # created and places the order by removing the requested products from inventory
  def place!(payment_nonce)
    return false unless valid?

    was_successful = false
    ActiveRecord::Base.transaction do
      save
      reload
      create_payment(payment_nonce)
      remove_items_from_inventory
      remove_items_from_cart
      self.date_placed = Time.now
      was_successful = save
    end
    OrderMailer.with(order: self).placed.deliver_now if was_successful
    was_successful
  end

  def fulfill!
    self.date_fulfilled = Time.now
    was_successful = save!
    OrderMailer.with(order: self).fulfilled.deliver_now if was_successful && being_picked_up?
    was_successful
  end

  def cancel!
    self.date_canceled = Time.now
    was_successful = save!
    OrderMailer.with(order: self).canceled.deliver_now if was_successful && placed?
    was_successful
  end

  def close!
    self.date_closed = Time.now
    was_successful = save!
    if being_shipped? && was_successful
      OrderMailer.with(order: self).shipped.deliver_now
    elsif was_successful
      OrderMailer.with(order: self).picked_up.deliver_now
    end
    was_successful
  end

  # the orders status in its lifecycle
  def status
    return :canceled if date_canceled?
    return :closed if closed?
    return :fulfilled if fulfilled?
    return :placed if placed?

    :open
  end

  # order has been paid for and is awaiting shipment and delivery
  def placed?
    date_placed.present?
  end

  # order is open and has yet to be paid, shipped, or delivered
  def open?
    date_created.present? && !closed? && !canceled?
  end

  def canceled?
    date_canceled.present?
  end

  def closed?
    date_closed.present?
  end

  # if the order is able to be edited
  def editable?
    return true if status == :open

    false
  end

  def can_be_placed?
    return false if placed? || paid_in_full?
    return true if being_picked_up? && paid_with_cash?

    false
  end

  def can_be_canceled?
    return false if canceled? || closed?

    true
  end

  private

  def create_payment(payment_nonce)
    payment = Payment.new(
      status: :created,
      method: payment_method,
      amount: total_balance,
      created_by_user_id: customer.id
    )
    service = Ares::PaymentService.new(payment)
    if service.attempt(self, payment_nonce)
      payments << payment
      true
    else
      false
    end
  end

  def create_payload_valid?(params)
    params[:payment_method_nonce].present?
  end

  def remove_items_from_inventory
    items.each do |i|
      i.config.remove_stock(i.quantity)
    end
  end

  def remove_items_from_cart
    CartItem.for(customer).as_of(date_created).delete_all
  end
end
