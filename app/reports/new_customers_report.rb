# frozen_string_literal: true

class NewCustomersReport
  def initialize(params)
    @start_date = params[:start_date]
    @end_date = params[:end_date] ||= Time.zone.now
  end

  attr_reader :start_date, :end_date

  def raw_data
    return nil if customers.nil?

    @raw_data ||= customers
  end

  private

  def customers
    User.customers
        .where('created_at BETWEEN :start_date AND :end_date', start_date: start_date, end_date: end_date)
        .order(:created_at)
  end
end
