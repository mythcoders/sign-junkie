# frozen_string_literal: true

class Invoice < ApplicationRecord
  has_paper_trail
  has_many :items, class_name: 'InvoiceItem'
  has_many :payments
  has_many :refunds
  belongs_to :customer, class_name: 'User', foreign_key: 'user_id'

  validates_presence_of :due_date
  accepts_nested_attributes_for :payments, :items

  scope :recently_created, -> { where('created_at > ?', Time.zone.now - 24.hours) }

  def self.new_from_cart(user, pay_with_gift_card, created_at = Time.zone.now)
    invoice = Invoice.new(user_id: user.id,
                          status: :draft,
                          due_date: Time.zone.today,
                          created_at: created_at)

    Cart.for(user).as_of(invoice.created_at).each do |cart|
      invoice.items << InvoiceItem.new(item_description_id: cart.description.id)
    end

    if pay_with_gift_card == 'true' && user.credit_balance.positive?
      invoice.payments << if invoice.grand_total <= user.credit_balance
                            Payment.new(amount: invoice.grand_total, method: 'gift_card')
                          else
                            Payment.new(amount: user.credit_balance, method: 'gift_card')
                          end
    end

    invoice
  end

  def self.new_from_seat(user, pay_with_gift_card, seat_id)
    invoice = Invoice.new(user_id: user.id,
                          status: :draft,
                          due_date: Time.zone.today,
                          created_at: created_at)

    Seat.find(seat_id) do |seat|
      invoice.items << InvoiceItem.new(item_description_id: seat.description.id)
    end

    if pay_with_gift_card == 'true' && user.credit_balance.positive?
      invoice.payments << if invoice.grand_total <= user.credit_balance
                            Payment.new(amount: invoice.grand_total, method: 'gift_card')
                          else
                            Payment.new(amount: user.credit_balance, method: 'gift_card')
                          end
    end

    invoice
  end

  # total balance remaining that needs paid
  def balance
    (grand_total - amount_paid).round(2)
  end

  # total due for the invoice
  def grand_total
    (sub_total + tax_total).round(2)
  end

  # total of all line items before tax
  def sub_total
    (items.map(&:item_amount).reduce(:+) || 0.00).round(2)
  end

  # total amount of tax due for the invoice
  def tax_total
    (items.map(&:tax_amount).reduce(:+) || 0.00).round(2)
  end

  # total of all payments applied
  def amount_paid
    (payments.map(&:amount).reduce(:+) || 0.00).round(2)
  end

  def taxed?
    items.any?(&:taxed?)
  end

  def draft?
    status == 'draft'
  end

  def paid?
    status == 'paid'
  end

  def past_due?
    !paid? && due_date < Time.zone.now
  end

  def cancelable_items
    items.select(&:refundable?)
  end
end
