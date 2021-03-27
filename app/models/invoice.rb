# frozen_string_literal: true

class Invoice < ApplicationRecord
  include AASM
  has_paper_trail
  has_many :items, class_name: 'InvoiceItem', dependent: :restrict_with_error
  has_many :payments, dependent: :restrict_with_error
  has_many :refunds, dependent: :restrict_with_error
  belongs_to :customer, class_name: 'User', foreign_key: 'user_id'

  validates_presence_of :due_date
  validate :invoice_has_items
  accepts_nested_attributes_for :payments, :items

  scope :recently_created, -> { where('created_at > ?', Time.zone.now - 24.hours) }

  aasm column: :status do
    state :draft, initial: true
    state :paid
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

  def past_due?
    !paid? && due_date < Time.zone.now
  end

  def cancelable_items
    items.select(&:refundable?)
  end

  private

  def invoice_has_items
    errors.add(:base, I18n.t('cart.empty')) if items.empty?
  end
end
