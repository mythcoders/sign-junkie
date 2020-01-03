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
    (data.map(&:tax_amount).reduce(:+) || 0.00).round(2)
  end

  def taxes_paid
    0.00
  end

  def taxable_sales
    (data.map(&:taxable_amount).reduce(:+) || 0.00).round(2)
  end

  def nontaxable_sales
    (data.map(&:nontaxable_amount).reduce(:+) || 0.00).round(2)
  end

  private

  def data
    return nil if tax_period.nil?

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
