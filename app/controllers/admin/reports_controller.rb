# frozen_string_literal: true

module Admin
  class ReportsController < AdminController
    before_action :tax_periods, only: %i[sales_tax]
    before_action :workshops, only: %i[guest_list]

    def sales_tax
      @report = SalesTaxReport.new(sales_tax_params) if params[:tax_period_id].present?

      respond_to do |format|
        format.turbo_stream { render "sales_tax", locals: {report: @report} }
        format.html
      end
    end

    def new_customers
      if params[:start_date].present? || params[:end_date].present?
        @report = NewCustomersReport.new(new_customers_params)
      end

      respond_to do |format|
        format.turbo_stream { render "new_customers", locals: {report: @report} }
        format.html
      end
    end

    def guest_list
      @report = GuestListReport.new(guest_list_params) if params[:workshop_id].present?

      respond_to do |format|
        format.turbo_stream { render "guest_list", locals: {report: @report} }
        format.html
      end
    end

    def credit_balances
      @report = CreditBalancesReport.new(credit_balances_params) if request.post?

      respond_to do |format|
        format.turbo_stream { render "credit_balances", locals: {report: @report} }
        format.html
      end
    end

    private

    def sales_tax_params
      {
        tax_period_id: params[:tax_period_id]
      }
    end

    def new_customers_params
      {
        start_date: convert_datetime(params[:start_date]),
        end_date: convert_datetime(params[:end_date])
      }
    end

    def guest_list_params
      {
        workshop_id: params[:workshop_id]
      }
    end

    def credit_balances_params
      {
        include_zero_balances: ActiveModel::Type::Boolean.new.cast(params[:include_zero_balances])
      }
    end

    def tax_periods
      @tax_periods ||= TaxPeriod.all
    end

    def workshops
      @workshops ||= Workshop.all
    end
  end
end
