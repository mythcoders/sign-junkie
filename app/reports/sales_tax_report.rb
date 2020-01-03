# frozen_string_literal: true

class SalesTaxReport
  def initialize(tax_period_id)
    @tax_period_id = tax_period_id
  end

  def start_date
    @start_date ||= tax_period.start_date
  end

  def end_date
    @end_date ||= next_tax_period.present? ? next_tax_period.start_date - 1.day : Time.zone.now
  end

  def tax_collected
    (raw_data.map(&:tax_amount).reduce(:+) || 0.00).round(2)
  end

  def taxes_paid
    0.00
  end

  def total_sales
    taxable_sales + nontaxable_sales
  end

  def taxable_sales
    (raw_data.map(&:taxable_amount).reduce(:+) || 0.00).round(2)
  end

  def nontaxable_sales
    (raw_data.map(&:nontaxable_amount).reduce(:+) || 0.00).round(2)
  end

  def raw_data
    return nil if tax_period.nil?

    @raw_data ||= purchased_items
  end

  private

  def purchased_items
    ItemDescription
      .joins(:invoice_items)
      .where('invoice_items.created_at BETWEEN ? and ?', start_date, end_date)
      .where(cancel_date: nil, void_date: nil, refund_date: nil)
  end

  def tax_period
    @tax_period ||= TaxPeriod.find @tax_period_id
  end

  def next_tax_period
    periods = TaxPeriod.where('start_date > ?', start_date).order(:start_date)
    @next_tax_period ||= periods.any? ? periods.first : nil
  end
end
