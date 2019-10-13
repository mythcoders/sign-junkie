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
      flash[:error] = 'No items to checkout'
      redirect_to cart_index_path
    end

    return process_invoice @invoice unless @invoice.balance.positive?

    @payment = Payment.new
    @client_token = BraintreeService.new.token
  end

  def create
    @invoice = Invoice.new_from_cart(current_user, params[:gift_cards], invoice_params[:created_at])
    if @invoice.balance.positive?
      @invoice.payments << Payment.new(amount: @invoice.balance,
                                       auth_token: params.fetch(:payment_method_nonce, nil))
    end
    process_invoice @invoice
  end

  private

  def invoice_params
    params.require(:invoice).permit(:created_at)
  end

  def process_invoice(invoice)
    raise ProcessError, t('order.create.failure') unless InvoiceService.new.place!(invoice)

    flash[:success] = t('order.placed.success')
    redirect_to invoice_path invoice
  rescue ProcessError => e
    flash[:error] = e.message
    redirect_to cart_index_path
  end
end
