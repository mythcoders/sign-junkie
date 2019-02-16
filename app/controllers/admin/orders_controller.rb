# frozen_string_literal: true

module Admin
  class OrdersController < AdminController
    before_action :get, only: %i[show edit update cancel close]

    def index
      @orders = Order.includes(:customer)
                     .order(created_at: :desc)
                     .page(params[:page])
                     .per(10)
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
      service = OrderService.new(@order)
      if service.cancel
        flash[:success] = 'Order has been canceled'
        redirect_to admin_order_path(@order)
      else
        flash[:error] = t('order.update.failure')
        render 'show'
      end
    end

    def close
      service = OrderService.new(@order)
      if service.close
        flash[:success] = 'Order has been closed!'
        redirect_to admin_order_path(@order)
      else
        flash[:error] = t('order.update.failure')
        render 'show'
      end
    end

    private

    def get
      @order = Order.includes(:items, :customer).find(params[:id])
    end

    def order_params
      params.require(:order).permit(:id, :date_canceled, :date_placed)
    end

    def filtered_params
      parameters = order_params
      parameters[:date_placed] = convert_datetime(parameters[:date_placed])
      parameters[:date_canceled] = convert_datetime(parameters[:date_canceled])
      parameters
    end
  end
end
