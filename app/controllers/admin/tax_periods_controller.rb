# frozen_string_literal: true

module Admin
  class TaxPeriodsController < AdminController
    before_action :set_tax_period, only: %i[show edit update destroy]

    def index
      @q = TaxPeriod.ransack(params[:q])
      @q.sorts = 'start_date asc' if @q.sorts.empty?
      @tax_periods = @q.result(distinct: true).page(params[:page])
    end

    def new
      @tax_period = TaxPeriod.new(amount_paid: 0.00)
    end

    def create
      @tax_period = TaxPeriod.new(filtered_params)

      if @tax_period.save
        flash[:success] = t('create.success')
        redirect_to admin_tax_periods_path
      else
        render 'new'
      end
    end

    def update
      if @tax_period.update(filtered_params)
        flash[:success] = t('update.success')
        redirect_to admin_tax_periods_path
      else
        render 'edit'
      end
    end

    def destroy
      if @tax_period.destroy
        flash[:success] = t('destroy.success')
        redirect_to admin_tax_periods_path
      else
        flash[:error] = t('destroy.failure')
        redirect_to edit_admin_tax_period_path(@tax_period)
      end
    end

    private

    def set_tax_period
      @tax_period = TaxPeriod.find params[:id]
    end

    def tax_period_params
      params.require(:tax_period).permit(:id, :start_date, :due_date, :amount_paid)
    end

    def filtered_params
      parameters = tax_period_params
      parameters[:start_date] = convert_datetime(parameters[:start_date])
      parameters[:due_date] = convert_datetime(parameters[:due_date])

      parameters
    end
  end
end
