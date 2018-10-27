# frozen_string_literal: true

module Taxable
  extend ActiveSupport::Concern

  # if the order is taxable
  def taxed?
    true
  end

  def total_taxable
    total_line_items
  end

  # Total amount due for taxes. Returns 0.00 if the order isn't taxable
  def total_tax
    return 0.00 unless taxed?

    (total_taxable * Ares::PaymentService.tax_rate).round(2)
  end
end
