# frozen_string_literal: true

# Debit given by the customer for an order
class Payment < ApplicationRecord
  audited
  has_many :order_items

  validates_presence_of :amount, :method, :identifier, :tax_rate, :tax_amount

  def self.build(amount, method, user_id)
    Payment.new(
      status: :created,
      method: method,
      date_created: Time.now,
      amount: amount,
      user_id: user_id
    )
  end

  def paypal?
    method == 'paypal'
  end

  def in_progress?
    status == 'created'
  end

  def posted?
    date_posted.present?
  end

  def editable?
    status == :created
  end
end
