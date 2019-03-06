# frozen_string_literal: true

# Debit given by the customer for an order
class Payment < ApplicationRecord

  SALES_TAX_ENABLED = true
  SALES_TAX_RATE = BigDecimal.new("0.0725")

  audited
  has_many :order_items
  belongs_to :customer, class_name: 'User', foreign_key: 'user_id'

  attr_accessor :method_nonce
  validates_presence_of :amount, :method, :identifier, :tax_rate, :tax_amount

  def self.build(user_id, items)
    payment = Payment.new(
      user_id: user_id,
      order_items: items,
      tax_rate: 0,
      tax_amount: 0
    )
    sub_total = payment.order_items.map(&:price).reduce(:+).round(2)

    if SALES_TAX_ENABLED
      payment.tax_rate = SALES_TAX_RATE
      payment.tax_amount = (sub_total * payment.tax_rate).round(2)
    end

    payment.amount = (sub_total + payment.tax_amount).round(2)
    payment
  end

  def taxed?
    tax_rate.present? && tax_rate > 0.00
  end

  def tax_percentage
    tax_rate * 100
  end
end
