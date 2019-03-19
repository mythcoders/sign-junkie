class TaxRate < ApplicationRecord
  def self.current
    TaxRate.where('effective_date <= CURRENT_TIMESTAMP').order(effective_date: :desc).first
  end
end
