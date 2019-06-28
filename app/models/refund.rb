class Refund < ApplicationRecord
  has_paper_trail
  belongs_to :invoice
  belongs_to :refund_reason, required: false
  belongs_to :customer_credit, required: false

  def self.new_from_invoice(invoice)
    self.new(invoice: invoice,
             amount: invoice.cancelable_items.collect { |i| i.amount_refundable }.first)
  end

  def deduct!
    return false if persisted?

    remaining = self.amount
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

    self.save!
  end
end
