# frozen_string_literal: true

module Admin
  class OrdersController < AdminController
    before_action :get, only: %i[show edit fulfill ship pick_up]
    before_action :populate_addresses, only: %i[edit]

    def index
      @orders = Order.includes(:customer).all
    end

    def code
      @order = Order.includes(:items, :payments, :customer).where(order_number: params[:order_number]).first
      if @order.nil?
        flash[:error] = 'Order not found'
        redirect_to admin_path
      else
        render 'show'
      end
    end

    def update
      if @order.update(update_params)
        flash[:success] = 'Yes!'
        redirect_to new_order_payment_path(@order)
      else
        set_addresses
        render 'edit'
      end
    end

    private

    def get
      @order = Order.includes(:items, :payments, :customer)
                    .find(params[:id])
    end

    def populate_addresses
      @addresses = @order.customer.addresses
    end

    def update_params
      params.require(:order).permit(:id, :payment_method, :address_id, :date_canceled)
    end
  end
end
