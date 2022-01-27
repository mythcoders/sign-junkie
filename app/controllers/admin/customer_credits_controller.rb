# frozen_string_literal: true

module Admin
  class CustomerCreditsController < AdminController
    before_action :set_credit, only: %i[edit update destroy]

    def new
      @credit = CustomerCredit.new(user_id: params[:customer_id])
    end

    def create
      @credit = CustomerCredit.new(create_params)

      if @credit.save
        flash["success"] = t("create.success")
        CustomerMailer.with(customer_id: @credit.customer.id, gift_amount: @credit.balance).gift_card.deliver_later
        redirect_to admin_customer_path @credit.customer
      else
        render "new", status: :unprocessable_entity
      end
    end

    def update
      if @credit.update(update_params)
        flash["success"] = t("update.success")
        redirect_to admin_customer_path @credit.customer
      else
        render "edit", status: :unprocessable_entity
      end
    end

    def destroy
      if @credit.destroy
        flash[:success] = t("destroy.success")
        redirect_to admin_customer_path @credit.customer
      else
        flash[:error] = t("destroy.failure")
        redirect_to admin_customer_credit_path(@credit)
      end
    end

    private

    def set_credit
      @credit = CustomerCredit.find(params[:id])
    end

    def create_params
      parameters = params.require(:customer_credit).permit(:user_id, :starting_amount, :expiration_date)
      parameters[:balance] = parameters[:starting_amount]
      parameters
    end

    def update_params
      params.require(:customer_credit).permit(:user_id, :expiration_date)
    end
  end
end
