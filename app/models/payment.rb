class Payment < ApplicationRecord
  belongs_to :invoice
  has_many :refunds
end
