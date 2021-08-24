# frozen_string_literal: true

module Admin
  class CustomersController < AdminController
    before_action :set_customer, only: %i[edit show update destroy resend_confirmation]
    before_action :disabled_roles, only: %i[edit update]

    def index
      @q = User.customers.ransack(params[:q])
      @q.sorts = "last_name asc" if @q.sorts.empty?
      @customers = @q.result(distinct: true).page(params[:page])
    end

    def new
      @customer = User.new
    end

    def create
      @customer = User.invite!(customer_params.except(:id))
      if @customer
        flash["success"] = t("create.success")
        redirect_to admin_customer_path @customer
      else
        disabled_roles
        render "new", status: :unprocessable_entity
      end
    end

    def update
      if @customer.update(customer_params)
        flash["success"] = t("update.success")
        redirect_to admin_customer_path @customer
      else
        disabled_roles
        render "edit", status: :unprocessable_entity
      end
    end

    def destroy
      if @customer.destroy
        flash["success"] = t("destroy.success")
        redirect_to admin_customers_path
      else
        flash[:error] = t("destroy.failure")
        redirect_to edit_admin_customer_path(@customer)
      end
    end

    def remind
      CustomerMailer.with(customer_id: params[:id]).abandoned_cart.deliver_later
      flash[:success] = "Reminder sent"
      redirect_to admin_customer_path params[:id]
    end

    def resend_confirmation
      if @customer.invitation_sent_at
        @customer.deliver_invitation
      else
        @customer.send_confirmation_instructions
      end

      flash[:success] = "Confirmation Instructions resent"
      redirect_to admin_customer_path @customer
    end

    private

    def customer_params
      params.require(:user).permit(:first_name, :last_name, :role, :email, :locked_at, :failed_attempts)
    end

    def disabled_roles
      @disabled_roles = current_user.operator? ? %i[] : %i[employee admin operator]
    end

    def set_customer
      @customer = User.find(params[:id])
    end
  end
end
