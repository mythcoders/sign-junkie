# frozen_string_literal: true

# Debit given by the customer for an order
class Payment < ApplicationRecord
  audited
  belongs_to :order
  enum status: %i[created authorized authorization_expired processor_declined
                  gateway_reject failed voided submitted settling settled
                  settlement_declined settlement_pending]

  validates_presence_of :status, :amount, :method, :transaction_id

  def self.build(order, method, amount, user_id)
    Payment.new(
      status: :created,
      date_created: Time.now,
      method: method,
      amount: amount,
      user_id: order.customer.id
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
