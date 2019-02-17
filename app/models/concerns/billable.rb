# frozen_string_literal: true

# Models that can been billed
module Billable
  extend ActiveSupport::Concern

  included do
    belongs_to :customer, class_name: 'User', foreign_key: 'user_id'
    has_many :items, -> { order(:created_at) }, class_name: 'OrderItem'
    has_many :payments, through: :items
  end

  def items_deposit
    items.select { |i| i.for_deposit }
  end

  def items_no_deposit
    items.select { |i| !i.for_deposit }
  end

  # entire amount due for the order, includes items, tax, and shipping
  def total_due
    (total_taxable + total_tax).round(2)
  end

  # total of all the items in the order, does not include tax or shipping
  def total_line_items
    (items.map(&:price).reduce(:+) || 0.00).round(2)
  end

  # total of all payments made by the customer
  def total_paid
    (payments.map(&:amount).reduce(:+) || 0.00).round(2)
  end

  # total amount due for the entire invoice
  def total_balance
    (total_due - total_paid).round(2)
  end

  # total amount due as a deposit, only applicatble for certain workshops
  def total_deposit
    (items_deposit.map(&:price).reduce(:+) || 0.00).round(2)
  end

  def total_public_shops
    ## clean up
    rv = 0.00
    items_no_deposit.each do |i|
      if i.tickets.any? { |t| t.workshop.is_public? }
        rv += i.price
      end
    end
    rv.round(2)
  end

  # Items that are due for payment
  #
  # IF the order has yet to be placed
  #   The amount for all line items that belong to a PUBLIC workshop
  #   The deposits for all PRIVATE workshops
  # ELSIF order has been placed and we're selecting a project/addon
  #   Amount due for the project/addon only
  # ELSE
  #  Remaining balance
  # END
  def due_now(user_id = nil)
    if !persisted?
      items.select { |i| i.workshop.is_public? || i.for_deposit? }
    elsif user_id.present?
      items.where(user_id: user_id)
    else
      items.where.not(payment_id: nil)
    end
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
