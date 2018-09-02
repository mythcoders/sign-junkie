# frozen_string_literal: true

module Taxable
  extend ActiveSupport::Concern

  # if the order is taxable
  def taxed?
    true
  end

  # total amount due for taxes
  # returns 0.00 if the order isn't taxable
  def total_tax
    0.00 unless taxed?
    total_line_items * tax_rate
  end

  private

  def calc_tax_rate
    taxed? ? 0.0725 : 0.00
  end
end
