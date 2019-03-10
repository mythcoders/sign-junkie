class Invoice < ApplicationRecord
  has_many :items, class_name: 'InvoiceItem'
  has_many :payments
  belongs_to :customer, class_name: 'User', foreign_key: 'user_id'
  belongs_to :seat, optional: true

  # total of all line items before tax
  def sub_total
    (items.map(&:pre_tax_amount).reduce(:+) || 0.00).round(2)
  end

  # total amount of tax due for the invoice
  def tax_total
    (items.map(&:tax_amount).reduce(:+) || 0.00).round(2)
  end

  # total of all payments applied
  def amount_paid
    (payments.map(&:amount).reduce(:+) || 0.00).round(2)
  end

  # total due for the invoice
  def grand_total
    (subtotal + tax_total).round(2)
  end

  # total balance remaining that needs paid
  def balance
    (grand_total - amount_paid).round(2)
  end
end