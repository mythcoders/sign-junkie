# frozen_string_literal: true

module Admin
  class ReportsController < AdminController
    before_action :tax_periods, only: %i[sales_tax]

    def sales_tax
      @report = SalesTaxReport.new(sales_tax_params) if sales_tax_params.present?
    end

    private

    def sales_tax_params
      params[:tax_period_id]
    end

    def tax_periods
      @tax_periods ||= TaxPeriod.all
    end
  end
end
