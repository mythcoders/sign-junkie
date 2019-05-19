# frozen_string_literal: true

module Admin
  class CustomerCreditsController < AdminController
    before_action :set_credit, only: %i[edit update]

    def new
      @credit = CustomerCredit.new(user_id: params[:customer_id])
    end

    def create
      @credit = CustomerCredit.new(create_params)

      if @credit.save
        flash['success'] = t('CreateSuccess')
        redirect_to admin_customer_path @credit.customer
      else
        render 'new'
      end
    end

    def update
      if @credit.update(update_params)
        flash['success'] = t('UpdateSuccess')
        redirect_to admin_customer_path @credit.customer
      else
        render 'edit'
      end
    end

    private

    def set_credit
      @credit = CustomerCredit.find(params[:id])
    end

    def create_params
      parameters = params.require(:customer_credit).permit(:id, :user_id, :starting_amount, :expiration_date)
      parameters[:expiration_date] = convert_date(parameters[:expiration_date])
      parameters
    end

    def update_params
      parameters = params.require(:customer_credit).permit(:id, :user_id, :expiration_date)
      parameters[:expiration_date] = convert_date(parameters[:expiration_date])
      parameters
    end
  end
end
