# frozen_string_literal: true

class Order < ApplicationRecord
  include Billable

  audited
  scope :current, ->(user_id) { where(user_id: user_id).order(:id) if user_id.present? }

  enum status: {
    created: 'created',
    placed: 'placed'
  }

  attr_readonly :order_number
  accepts_nested_attributes_for :items
  validates_presence_of :user_id

  # builds an order for the user based on the contents of their cart
  def self.build(user, date_created = Time.now)
    order = Order.new(date_created: date_created, status: 'created', user_id: user.id)
    CartItem.for(user).as_of(order.date_created).each do |cart_item|
      cart_item.quantity.times do
        order.items << OrderItem.create(cart_item)
      end
      order.items << OrderItem.deposit(cart_item) if cart_item.workshop.is_private?
    end
    order
  end

  # the orders status in its lifecycle
  def status
    return :canceled if canceled?
    return :closed if closed?
    return :fulfilled if fulfilled?
    return :placed if placed?

    :open
  end

  def tax_percentage
    tax_rate * 100
  end

  # order has been paid for and is awaiting shipment and delivery
  def placed?
    date_placed.present?
  end

  # order is open and has yet to be paid, shipped, or delivered
  def open?
    persisted? && !closed? && !canceled?
  end

  def canceled?
    date_canceled.present?
  end

  def fulfilled?
    # TODO: Calculate
  end

  def closed?
    # TODO: Calculat
  end

  # if the order is able to be edited
  def editable?
    return true if status == :open

    false
  end

  def can_be_canceled?
    return false if canceled? || closed?

    true
  end

  private

  def create_payload_valid?(params)
    params[:payment_method_nonce].present?
  end
end
