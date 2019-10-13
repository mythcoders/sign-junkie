# frozen_string_literal: true

class Refund < ApplicationRecord
  has_paper_trail
  belongs_to :invoice
  belongs_to :refund_reason, required: false
  belongs_to :customer_credit, required: false

  def deduct!
    return false if persisted?

    remaining = amount
    invoice.payments.each do |payment|
      refundable = payment.amount_refundable
      if refundable >= remaining
        payment.refund! remaining
        remaining -= remaining
      else
        payment.refund! refundable
        remaining -= refundable
      end

      payment.save!
      break if remaining.zero?
    end

    save!
  end
end
