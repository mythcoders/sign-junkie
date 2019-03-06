# frozen_string_literal: true

class Invoice < ApplicationRecord
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
    order = Invoice.new(date_created: date_created, status: 'created', user_id: user.id)
    Cart.for(user).as_of(order.date_created).each do |cart_item|
      cart_item.quantity.times do
        order.items << InvoiceItem.create(cart_item)
      end
      order.items << InvoiceItem.deposit(cart_item) if cart_item.workshop.is_private?
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
end
