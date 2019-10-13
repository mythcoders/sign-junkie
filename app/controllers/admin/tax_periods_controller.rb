# frozen_string_literal: true

module Admin
  class TaxPeriodsController < AdminController
    before_action :set_tax_period, only: %i[show edit update]

    def index
      @tax_periods = TaxPeriod.all.page(params[:page])
    end

    def new
      @tax_period = TaxPeriod.new
    end

    def create
      @tax_period = TaxPeriod.new(tax_period_params)

      if @tax_period.save
        flash[:success] = t('CreateSuccess')
        redirect_to admin_period_path @tax_period
      else
        render 'new'
      end
    end

    def update
      if @tax_period.update(tax_period_params)
        flash[:success] = t('UpdateSuccess')
        redirect_to admin_tax_period_path @tax_period
      else
        render 'edit'
      end
    end

    private

    def set_tax_period
      @tax_period = TaxPeriod.find params[:id]
    end

    def tax_period_params
      params.require(:tax_period).permit(:id, :start_date, :end_date, :amount_paid)
    end
  end
end
