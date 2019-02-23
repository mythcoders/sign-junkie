class OrderItemsController < ApplicationController
  before_action :authenticate_user!

  def show
    @order_item = OrderItem.includes(:order).find(params[:id])
  end

  def assign
    order_item = OrderItem.includes(:order).find(params[:order_item_id])
    service = OrderService.new(order_item.order, current_user)
    if service.assign(order_item, assign_params)
      flash[:success] = 'Seat was assigned and person has been notified!'
    else
      flash[:error] = 'Sorry, error'
    end
    redirect_to order_path service.order
  end

  def create

  end

  def update

  end

  def cancel
    order = Order.find(params[:order_id])
    service = OrderService.new(order, current_user)
    if service.cancel(cancel_params)
      flash[:success] = 'Ticket(s) have been canceled'
    else
      flash[:error] = 'Sorry, error'
    end
    redirect_to orders_path service.order
  end

  def by_workshop
    @workshop = Workshop.find(params[:workshop_id])
    @order_items = OrderItem.where(for_deposit: false,
                                   order_id: params[:order_id],
                                   workshop_id: @workshop.id)
  end

  private

  def cancel_params
    params.require(:cancel).permit(:order_item_ids)
  end

  def assign_params
    params.require(:order_item).permit(:id, :first_name, :last_name, :email)
  end
end
