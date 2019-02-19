# frozen_string_literal: true

# Controller for root/orders
class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: %i[show receipt cancel]
  before_action :check_order_auth, only: %i[show receipt cancel]
  before_action :build_order, only: %i[new create]
  before_action :set_cart_total, only: %i[index show new]
  before_action :check_cart_total, only: %i[new]
  before_action :prepare_payment, only: %i[new create]

  layout 'mailer', only: %i[receipt]

  def index
    @orders = Order.current(current_user.id).order(date_created: :desc)
  end

  def create
    @order.assign_attributes(create_params)
    service = OrderService.new(@order, current_user)
    @payment.method_nonce = params.fetch(:payment_method_nonce, nil)
    if service.place(@payment)
      flash[:success] = t('order.placed.success')
      redirect_to order_path service.order
    else
      order_create_error
    end
  end

  def new
    @client_token = PaymentService.new(@payment).new_token
  end

  def cancel
    service = OrderService.new(@order, current_user)
    if service.cancel
      flash[:success] = 'Order has been canceled'
      redirect_to order_path service.order
    else
      flash[:error] = 'Sorry, error'
      render 'show'
    end
  end

  private

  def build_order
    @order = Order.build(current_user)
  end

  def set_order
    @order = Order.includes(:items, :customer).find(params[:id])
  end

  def check_cart_total
    redirect_to cart_path @order unless @cart_total.positive?
  end

  def check_order_auth
    unauthorized if @order.user_id != current_user.id
  end

  def create_params
    params.require(:order).permit(:date_created)
  end

  def prepare_payment
    @payment = Payment.build(current_user.id, @order)
  end

  def order_create_error
    flash[:error] = t('order.create.failure')
    set_cart_total
    prepare_payment
    render 'new'
    # redirect_to new_order_path
  end
end
