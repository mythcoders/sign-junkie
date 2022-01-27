# frozen_string_literal: true

module Admin
  class TaxRatesController < AdminController
    before_action :set_tax_rate, only: %i[edit update destroy]
    before_action :check_editable, only: %i[edit update destroy]

    def index
      @q = TaxRate.ransack(params[:q])
      @q.sorts = "effective_date asc" if @q.sorts.empty?
      @tax_rates = @q.result(distinct: true).page(params[:page])
    end

    def new
      @tax_rate = TaxRate.new
    end

    def create
      @tax_rate = TaxRate.new(filtered_params)

      if @tax_rate.save
        flash[:success] = t("create.success")
        redirect_to admin_tax_rates_path
      else
        render "new", status: :unprocessable_entity
      end
    end

    def update
      if @tax_rate.update(filtered_params)
        flash[:success] = t("update.success")
        redirect_to admin_tax_rates_path
      else
        render "edit", status: :unprocessable_entity
      end
    end

    def destroy
      if @tax_rate.destroy
        flash[:success] = t("destroy.success")
        redirect_to admin_tax_rates_path
      else
        flash[:error] = t("destroy.failure")
        redirect_to edit_admin_tax_rate_path(@tax_rate)
      end
    end

    private

    def set_tax_rate
      @tax_rate = TaxRate.find params[:id]
    end

    def tax_rate_params
      params.require(:tax_rate).permit(:rate, :effective_date)
    end

    def filtered_params
      parameters = tax_rate_params
      parameters[:rate] = (parameters[:rate].to_d / 100).to_s
      parameters
    end

    def check_editable
      return if @tax_rate.editable?

      flash[:error] = t("tax_rate.uneditable")
      redirect_to admin_tax_rates_path
    end
  end
end
