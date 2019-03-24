class InvoiceItem < ApplicationRecord
  belongs_to :invoice

  serialize :description, ItemDescription

  def pre_tax_total
    pre_tax_amount * quantity
  end

  def line_total
    pre_tax_total + tax_total
  end
end
