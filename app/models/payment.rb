class Payment < ApplicationRecord
  has_paper_trail
  belongs_to :invoice
  attr_accessor :auth_token

  scope :refundable, -> {
      where("method = 'braintree' AND amount_refunded IS NULL or amount_refunded < amount")
        .order(amount: :asc)
  }

  def amount_refundable
    amount - (amount_refunded || 0.00)
  end

  def gift_card?
    method == 'gift_card'
  end
end
