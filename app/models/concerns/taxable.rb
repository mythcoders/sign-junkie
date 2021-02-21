# frozen_string_literal: true

module Taxable
  extend ActiveSupport::Concern

  included do
    before_validation :apply_tax!
  end

  def taxable?
    return true if seat?

    false
  end

  def taxed?
    tax_rate.present?
  end

  def apply_tax!
    if TaxRate.enabled? && taxable?
      return unless tax_amount.nil? || taxable_amount_changed?

      self.tax_rate = TaxRate.current.rate
      self.tax_amount = (taxable_amount * tax_rate).round(2)
    else
      self.tax_rate = nil
      self.tax_amount = 0.00
    end
  end
end
