# frozen_string_literal: true

class Payment < ApplicationRecord
  has_paper_trail
  belongs_to :invoice
  attr_accessor :auth_token

  validates_presence_of :amount
  validate :auth_token_presence, on: :create
  scope :credit_cards, -> { where(method: 'credit_card') }
  scope :refundable_payments, -> { where.not(method: 'gift_card') }

  # TODO: : AP-242 make sure we don't refund more than paid
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

  def refundable?
    credit_card? || paypal?
  end

  private

  def auth_token_presence
    errors.add('', I18n.translate('order.payment.missing_token')) if !gift_card? && auth_token.nil?
  end
end
