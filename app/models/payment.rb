# frozen_string_literal: true

class Payment < ApplicationRecord
  has_paper_trail
  belongs_to :invoice
  attr_accessor :auth_token

  validates_presence_of :method, :amount
  scope :credit_cards, -> { where(method: 'credit_card') }

  # TODO: make sure we don't refund more than paid

  def amount_refundable
    amount - (amount_refunded || 0.00)
  end

  def gift_card?
    method == 'gift_card'
  end

  def paypal?
    method == 'paypal_account'
  end

  def credit_card?
    method == 'credit_card'
  end
end
