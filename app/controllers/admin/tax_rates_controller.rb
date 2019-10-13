# frozen_string_literal: true

module Admin
  class TaxRatesController < AdminController
    before_action :set_tax_rate, only: %i[show edit update]

    def index
      @tax_rates_grid = initialize_grid(TaxRate, order: 'effective_date')
    end

    def new
      @tax_rate = TaxRate.new
    end

    def create
      @tax_rate = TaxRate.new(tax_rate_params)

      if @tax_rate.save
        flash[:success] = t('CreateSuccess')
        redirect_to admin_tax_rate_path @tax_rate
      else
        render 'new'
      end
    end

    def update
      if @tax_rate.update(tax_rate_params)
        flash[:success] = t('UpdateSuccess')
        redirect_to admin_tax_rate_path @tax_rate
      else
        render 'edit'
      end
    end

    private

    def set_tax_rate
      @rax_rate = TaxRate.find params[:id]
    end

    def tax_rate_params
      params.require(:tax_rate).permit(:id, :rate, :effective_date)
    end
  end
end
