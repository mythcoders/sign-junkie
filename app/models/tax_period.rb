class TaxPeriod < ApplicationRecord
  validates_presence_of :start_date, :end_date, :due_date
end
