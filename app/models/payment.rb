class Payment < ApplicationRecord
  has_paper_trail
  belongs_to :invoice
  attr_accessor :auth_token

  validates_presence_of :method, :amount

  # todo: make sure we don't refund more than paid

  def amount_refundable
    amount - (amount_refunded || 0.00)
  end

  def refund!(refund_amount)
    self.amount_refunded += refund_amount
  end

  def gift_card?
    method == 'gift_card'
  end

  def paypal?
    method == 'paypal_account'
  end
end
