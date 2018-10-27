# frozen_string_literal: true

# Models that can been billed
module Billable
  extend ActiveSupport::Concern

  included do
    belongs_to :customer, class_name: 'User', foreign_key: 'user_id'
    belongs_to :address, optional: true
    has_many :payments
    has_many :items, -> { order(:created_at) }, class_name: 'OrderItem', inverse_of: :order
  end

  # entire amount due for the order, includes items, tax, and shipping
  def total_due
    (total_taxable + total_tax).round(2)
  end

  # total of all the items in the order, does not include tax or shipping
  def total_line_items
    (items.map(&:item_total).reduce(:+) || 0.00).round(2)
  end

  # total of all payments made by the customer
  def total_paid
    (payments.select(&:posted?).map(&:amount).reduce(:+) || 0.00).round(2)
  end

  # total amount due for the entire invoice
  def total_balance
    (total_due - total_paid).round(2)
  end

  # if the order has been paid for completely
  def paid_in_full?
    total_balance.zero?
  end

  # checks if a payment can be applied to the order
  def can_make_payment?
    return false unless open?

    !paid_in_full?
  end

  def paid_with_card?
    payment_method == 'card'
  end

  def paid_with_paypal?
    payment_method == 'paypal'
  end

  def ready_for_payment?
    if !placed? && payment_method.present?
      return true if address_id.present?
    end

    false
  end
end
