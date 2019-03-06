class TaxRate < ApplicationRecord
  validates_presence_of :rate, :effective_date
end
