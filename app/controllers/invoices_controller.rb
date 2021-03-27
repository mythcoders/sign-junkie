# frozen_string_literal: true

class InvoicesController < ApplicationController
  include BraintreePayments

  before_action :authenticate_user!
  before_action :build_invoice, only: %i[new create]
  before_action :set_client_token, only: %i[new]

  def index
    @invoices = current_user.invoices.page(params[:page]).order(created_at: :desc)
  end

  def show
    @invoice = current_user.invoices.includes(:items, :customer).find(params[:id])
  end

  def new
    if @invoice.items.empty?
      flash[:error] = t('cart.empty')
      redirect_to cart_index_path
    end

    return process_invoice unless @invoice.balance.positive?

    @payment = Payment.new
  end

  def create
    add_payment_to_invoice if @invoice.balance.positive?
    return process_invoice if @invoice.valid?

    flash[:error] = @invoice.errors.full_messages.to_sentence
    redirect_to cart_index_path
  end

  private

  def created_at_param
    params.fetch(:invoice, {}).fetch(:created_at, nil)
  end

  def payment_method_nonce_param
    params.fetch(:payment_method_nonce, nil)
  end

  def build_invoice
    @invoice = InvoiceService::Factory.build(current_user,
                                             params[:gift_cards],
                                             created_at_param || Time.zone.now)
  end

  def add_payment_to_invoice
    @invoice.payments << Payment.new(amount: @invoice.balance, auth_token: payment_method_nonce_param)
  end

  def process_invoice
    if InvoiceService::Processor.perform(@invoice)
      flash[:success] = t('order.placed.success')
      redirect_to my_account_path
    else
      flash[:error] = t('order.critical_failure')
      redirect_to cart_index_path
    end
  end
end
