# frozen_string_literal: true

# Controller for root/orders
class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: %i[show receipt cancel]
  before_action :check_order_auth, only: %i[show receipt cancel]
  before_action :build_order, only: %i[new ui create]
  before_action :set_addresses, only: %i[new]
  before_action :set_cart_total, only: %i[index show new]
  before_action :check_cart_total, only: %i[new]
  before_action :prepare_payment, only: %i[new ui]
  before_action :assign_create_params, only: %i[create ui]
  before_action :check_params, only: %i[create]

  layout 'mailer', only: %i[receipt]

  def index
    @orders = Order.current(current_user.id).order(date_created: :desc)
  end

  def create
    service = Ares::OrderService.new(@order)
    if service.place(params.fetch(:payment_method_nonce, nil))
      flash[:success] = t('order.placed.success')
      redirect_to order_path @order
    else
      order_create_error
    end
  end

  def cancel
    service = Ares::OrderService.new(@order)
    if service.cancel
      flash[:success] = 'Order has been canceled'
      redirect_to order_path(@order)
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
    @order = Order.includes(:items, :payments, :address, :customer).find(params[:id])
  end

  def check_cart_total
    redirect_to cart_path @order unless @cart_total.positive?
  end

  def set_addresses
    @addresses = current_user.addresses
  end

  def check_order_auth
    unauthorized if @order.user_id != current_user.id
  end

  def create_params
    params.require(:order).permit(:date_created, :payment_method, :address_id)
  end

  def prepare_payment
    @client_token = Ares::PaymentService.new(@order).new_token
  end

  def assign_create_params
    @order.assign_attributes(create_params)
  end

  def check_params
    order_create_error unless params.fetch(:payment_method_nonce, nil).present?
  end

  def order_create_error
    flash[:error] = t('order.create.failure')
    set_addresses
    set_cart_total
    prepare_payment
    render 'new'
  end
end
