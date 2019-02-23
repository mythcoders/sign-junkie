class OrderItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_order_item, only: %i[update]

  def create

  end

  def cancel
    order = Order.find(params[:order_id])
    service = OrderService.new(order, current_user)
    if service.cancel(cancel_params)
      flash[:success] = 'Ticket(s) have been canceled'
    else
      flash[:error] = 'Sorry, error'
    end
    redirect_to order_path service.order
  end

  def by_workshop
    @workshop = Workshop.find(params[:workshop_id])
    @order_items = OrderItem.where(for_deposit: false,
                                   order_id: params[:order_id],
                                   workshop_id: @workshop.id)
  end

  private

  def get_order_item
    @order_item = OrderItem.find(params[:id])
  end

  def cancel_params
    params.require(:cancel).permit(:order_item_ids)
  end

  def item_params

  end
end
