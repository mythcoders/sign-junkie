class Refund < ApplicationRecord
  has_paper_trail
  belongs_to :invoice
  belongs_to :refund_reason, required: false
  has_one :customer_credit, required: false

  def self.new_from_invoice(invoice)
    self.new(invoice: invoice,
             amount: invoice.cancelable_items.collect { |i| i.refundable_total }.first)
  end
end
