class OrderItemsController < ApplicationController
  before_action :authenticate_user!

  def show
    @order_item = OrderItem.includes(:order).find(params[:id])
  end

  def create

  end

  def edit
    @order_item = OrderItem.includes(:order).find(params[:id])
    #@order_item.project_id = @order_item.workshop.projects.detect { |i| i.name == @order_item.project }.id
    #@order_item.design_id = @order_item.workshop.designs.detect { |i| i.name == @order_item.design }.id
    #@order_item.addon_id = @order_item.workshop.addons.detect { |i| i.name == @order_item.addon }.id
    build_payment if @order_item.can_pay?
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

  def update
    @order_item = OrderItem.includes(:order).find(params[:id])
    service = OrderService.new(@order_tem.order, current_user)
    if service.modify(@order_item, update_params)
      flash['success'] = t('UpdateSuccess')
      redirect_to edit_order_order_item_path @order_item
    else
      flash['success'] = t('UpdateFailure')
      render 'edit'
    end
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

  def build_payment
    @payment = Payment.build(current_user.id, [@order_item])
    @client_token = PaymentService.new(@payment).new_token
  end

  def update_params
    params.require(:order_item).permit(:id, :project_id, :design_id, :design, :addon_id, :seating)
  end

  def cancel_params
    params.require(:cancel).permit(:order_item_ids)
  end

  def assign_params
    params.require(:order_item).permit(:id, :first_name, :last_name, :email)
  end
end
