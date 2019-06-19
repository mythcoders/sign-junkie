class TaxRate < ApplicationRecord
  has_paper_trail

  def self.current
    TaxRate.where('effective_date <= CURRENT_TIMESTAMP')
            .order(effective_date: :desc)
            .first
  end

  def self.enabled?
    TaxRate.current.rate.positive?
  end
end
