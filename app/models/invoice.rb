class Invoice < ApplicationRecord
  has_many :items, class: 'InvoiceItem'
  has_many :payments
  belongs_to :user
  belongs_to :seat, optional: true
end
