class InvoiceItem < ApplicationRecord
  has_paper_trail
  belongs_to :invoice
  belongs_to :description, class_name: 'ItemDescription', foreign_key: 'item_description_id'

  delegate_missing_to :description
end
