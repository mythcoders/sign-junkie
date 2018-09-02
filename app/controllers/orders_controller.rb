# frozen_string_literal: true

# Controller for root/orders
class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :get, only: %i[show receipt edit update]
  before_action :check_order_auth, only: %i[show edit update]
  before_action :check_editable, only: %i[edit update]
  before_action :set_addresses, only: %i[edit]
  before_action :set_cart_total, only: %i[show edit]

  layout 'mailer', only: %i[receipt]

  def index
    @orders = Order.current(current_user.id)
  end

  def show
    redirect_to edit_order_path @order if @order.editable?
  end

  def receipt
    render text: 'receipt'
  end

  def edit
    pending = @order.payments.select(&:in_progress?)
    unless pending.nil?
      redirect_to edit_order_payment_path(@order, pending.first) if pending.any?
    end
    flash[:info] = t('user.need_addresses') if @addresses.empty?
  end

  def create
    @order = Order.new(create_params)
    if @order.create(current_user.id)
      flash[:success] = t('order.create.success')
      redirect_to edit_order_path @order
    else
      flash[:error] = t('order.create.failure')
      redirect_to cart_index_path
    end
  end

  def update
    if @order.update(update_params)
      if params[:pay] && @order.ready_for_payment?
        return redirect_to edit_order_payment_path(@order, @payment) if prepare_payment
      else
        flash[:success] = t('order.update.success')
        return redirect_to edit_order_path(@order)
      end
    end
    set_addresses
    render 'edit'
  end

  private

  def get
    @order = Order.includes(:items,
                            :payments,
                            :address,
                            :customer,
                            :notes)
                  .find(params[:id])
  end

  def prepare_payment
    @payment = Payment.build(@order.id, current_user.id)
    @payment.save
  end

  def set_addresses
    @addresses = current_user.addresses
  end

  def check_order_auth
    unauthorized if @order.user_id != current_user.id
  end

  def check_editable
    unauthorized unless @order.editable?
  end

  def create_params
    params.require(:order).permit(:id, :user_id)
  end

  def update_params
    params.require(:order).permit(:id,
                                  :payment_method,
                                  :address_id)
  end
end
