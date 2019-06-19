module Taxable
  extend ActiveSupport::Concern

  included do
    before_save :apply_tax!
  end

  def taxable?
    return true if self.seat?

    false
  end

  def taxed?
    self.tax_rate.present?
  end

  def apply_tax!
    if TaxRate.enabled? && self.taxable?
      return unless self.taxable_amount_changed?

      self.tax_rate = TaxRate.current.rate
      self.tax_amount = (self.taxable_amount * self.tax_rate).round(2)
    else
      self.tax_rate = nil
      self.tax_amount = 0.00
    end
  end
end
