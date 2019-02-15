# frozen_string_literal: true

module Taxable
  extend ActiveSupport::Concern

  def total_taxable
    total_line_items
  end

  # Total amount due for taxes. Returns 0.00 if the order isn't taxable
  def total_tax
    return 0.00 unless Ares::OrderService.taxed?

    (total_taxable * Ares::OrderService.tax_rate).round(2)
  end
end
