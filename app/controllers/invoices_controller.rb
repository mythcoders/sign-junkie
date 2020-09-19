# frozen_string_literal: true

class InvoicesController < ApplicationController
  before_action :authenticate_user!

  def index
    @invoices = current_user.invoices.page(params[:page]).order(created_at: :desc)
  end

  def show
    @invoice = current_user.invoices.includes(:items, :customer).find(params[:id])
  end

  def new
    @invoice = Invoice.new_from_cart(current_user, params[:gift_cards])
    if @invoice.items.empty?
      flash[:error] = t('cart.empty')
      redirect_to cart_index_path
    end

    return process_invoice unless @invoice.balance.positive?

    @payment = Payment.new
    @client_token = BraintreeService.new.token
  end

  def create
    @invoice = Invoice.new_from_cart(current_user, params[:gift_cards], invoice_params[:created_at])
    create_payment if @invoice.balance.positive?

    if @invoice.valid?
      process_invoice
    else
      flash[:error] = @invoice.errors.full_messages.to_sentence
      redirect_to cart_index_path
    end
  rescue BraintreeService::PaymentError => e
    Raven.capture_exception(e)
    flash[:error] = "Payment Error: #{e.message}"
    redirect_to cart_index_path
    # rescue ProcessError => e
    #   Raven.capture_exception(e.message, level: 'warning')
    #   flash[:error] = if Rails.env.development?
    #                     "Critical Error: #{e.message}"
    #                   else
    #                     t('order.critical_failure')
    #                   end
    #   redirect_to cart_index_path
  end

  private

  def invoice_params
    params.require(:invoice).permit(:created_at)
  end

  def payment_method_nonce
    params.fetch(:payment_method_nonce, nil)
  end

  def create_payment
    @invoice.payments << Payment.new(amount: @invoice.balance, auth_token: payment_method_nonce)
  end

  def process_invoice
    if InvoiceService.new(@invoice).place!
      flash[:success] = t('order.placed.success')
      # Appsignal.increment_counter('orders.placed', 1)
      redirect_to my_account_path
    else
      flash[:error] = '?' # t('order.critical_failure')
      redirect_to cart_index_path
    end
  end
end
