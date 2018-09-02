# frozen_string_literal: true

class Order < ApplicationRecord
  include Taxable
  include Billable

  audited
  scope :current, ->(user_id) { where(user_id: user_id).order(:id) if user_id.present? }
  has_many :notes, class_name: 'OrderNote'

  def create(user_id)
    return_value = false
    ActiveRecord::Base.transaction do
      self.tax_rate = calc_tax_rate
      self.date_created = Time.now
      self.user_id = user_id
      cart = CartItem.includes(:event).where(user_id: user_id)
      cart.each do |cart_item|
        items << OrderItem.create(cart_item.event, cart_item.quantity, self)
      end
      return_value = save!
      cart.delete_all if return_value
    end
    return_value
  end

  # places the order by removing the requested products from inventory
  def place!
    errors.add('', 'not paid') unless paid_in_full?
    ActiveRecord::Base.transaction do
      items.each do |i|
        i.event.remove_stock(i.quantity)
      end
      self.date_placed = Time.now
      save
    end
    OrderMailer.with(order: self).placed.deliver_now
  end

  # the orders status in its lifecycle
  def status
    return :canceled if canceled?
    return :placed if placed?
    :open if open?
  end

  # order has been paid in full
  def placed?
    date_placed.present?
  end

  # order is open and has yet to be paid
  def open?
    date_created.present? && !canceled?
  end

  def canceled?
    date_canceled.present?
  end

  # if the order is able to be edited
  def editable?
    return true if status == :open
    false
  end

  def can_be_placed?
    return false if placed? || paid_in_full?
    # return true if being_picked_up? && paid_with_cash?
    false
  end

  def can_be_caneled?
    true
  end

  def total_tickets
    items.map(&:quantity).reduce(:+) || 0
  end
end
