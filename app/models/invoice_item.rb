class InvoiceItem < ApplicationRecord
  belongs_to :invoice

  serialize :description, ItemDescription
  delegate_missing_to :description

  def pre_tax_total
    pre_tax_amount * quantity
  end

  def line_total
    pre_tax_total + tax_amount
  end

  def taxed?
    tax_rate.present?
  end
end
