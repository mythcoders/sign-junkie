class InvoiceItem < ApplicationRecord
  belongs_to :invoice

  serialize :description, ItemDescription

  def item_total
    (pre_tax_amount + tax_amount) * quantity
  end
end
