# frozen_string_literal: true

module Admin
  class OrdersController < AdminController
    before_action :get, only: %i[show edit update cancel]
    before_action :populate_addresses, only: %i[edit]

    def index
      @orders = Order.includes(:customer).all
    end

    def update
      if @order.update(filtered_params)
        flash[:success] = 'Yes!'
        redirect_to admin_order_path(@order)
      else
        populate_addresses
        render 'edit'
      end
    end

    def cancel
      if @order.cancel!
        flash[:success] = 'Order has been canceled'
        redirect_to admin_order_path(@order)
      else
        flash[:error] = t('order.update.failure')
        render 'show'
      end
    end

    private

    def get
      @order = Order.includes(:items, :payments, :customer).find(params[:id])
    end

    def populate_addresses
      @addresses = @order.customer.addresses
    end

    def order_params
      params.require(:order).permit(:id, :payment_method, :address_id, :date_canceled, :date_placed)
    end

    def filtered_params
      parameters = order_params
      parameters[:date_placed] = convert_datetime(parameters[:date_placed])
      parameters[:date_canceled] = convert_datetime(parameters[:date_canceled])
      parameters
    end
  end
end
