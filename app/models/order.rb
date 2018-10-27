# frozen_string_literal: true

class Order < ApplicationRecord
  include Taxable
  include Billable

  audited
  scope :current, ->(user_id) { where(user_id: user_id).order(:id) if user_id.present? }
  has_many :notes, class_name: 'OrderNote'

  attr_readonly :order_number
  accepts_nested_attributes_for :items
  validates_presence_of :address_id, :payment_method, :user_id

  # builds an order for the user based on the contents of their cart
  def self.build(user, date_created = Time.now)
    order = Order.new(user_id: user.id, tax_rate: Ares::PaymentService.tax_rate, date_created: date_created)
    CartItem.for(user).as_of(order.date_created).each do |cart_item|
      order.items << OrderItem.create(cart_item.event, cart_item.quantity)
    end
    order
  end

  def cancel!
    self.date_canceled = Time.now
    was_successful = save!
    OrderMailer.with(order: self).canceled.deliver_now if was_successful && placed?
    was_successful
  end

  def close!
    self.date_closed = Time.now
    save!
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
    date_created.present? && !closed? && !canceled?
  end

  def canceled?
    date_canceled.present?
  end

  def fulfilled?
    date_fulfilled.present?
  end

  def total_tickets
    items.map(&:quantity).reduce(:+) || 0
  end

  def closed?
    date_closed.present?
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
