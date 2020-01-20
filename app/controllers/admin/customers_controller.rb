# frozen_string_literal: true

module Admin
  class CustomersController < AdminController
    before_action :get, only: %i[edit show update destroy]
    before_action :disabled_roles, only: %i[edit update]

    def index
      @customers_grid = initialize_grid(User.where(role: 'customer'), order: 'last_name')
    end

    def new
      @customer = User.new
    end

    def create
      @customer = User.invite!(customer_params.except(:id))
      if @customer
        flash['success'] = t('create.success')
        redirect_to admin_customer_path @customer
      else
        disabled_roles
        render 'new'
      end
    end

    def update
      if @customer.update(customer_params)
        flash['success'] = t('update.success')
        redirect_to admin_customer_path @customer
      else
        disabled_roles
        render 'edit'
      end
    end

    def destroy
      if @customer.destroy
        flash['success'] = t('destroy.success')
        redirect_to admin_customer_path @customer
      else
        flash[:error] = t('destroy.failure')
        redirect_to edit_admin_customer_path(@customer)
      end
    end

    def remind
      CustomerMailer.with(customer_id: params[:id]).abandoned_cart.deliver_later
      flash[:success] = 'Reminder sent'
      redirect_to admin_customer_path params[:id]
    end

    private

    def customer_params
      params.require(:user).permit(:first_name, :last_name, :role, :email)
    end

    def disabled_roles
      @disabled_roles = current_user.operator? ? %i[] : %i[employee admin operator]
    end

    def get
      @customer = User.includes(:invoices).find(params[:id])
    end
  end
end
