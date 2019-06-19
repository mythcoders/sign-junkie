class InvoicesController < ApplicationController
  before_action :authenticate_user!

  def index
    @invoices = current_user.invoices.page(params[:page]).order(created_at: :desc)
  end

  def show
    @invoice = Invoice.includes(:items, :customer).find(params[:id])
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
    @invoice = Invoice.new_from_cart(current_user, invoice_params[:created_at])
    @payment = Payment.new
    @payment.auth_token = params.fetch(:payment_method_nonce, nil)
    @payment.amount = @invoice.grand_total unless params[:gift_cards].present?
    @invoice.payments << @payment

    process_invoice @invoice
  end

  def cancel
    invoice = Invoice.find params[:id]
    begin
      if InvoiceService.new.cancel(invoice)
        flash[:success] = t('order.cancel.success')
        redirect_to invoice_path invoice
      else
        raise ProcessError, t('order.cancel.failure')
      end
    rescue ProcessError => e
      Raven.capture_exception(e.message, transaction: 'Cancel order')
      flash[:error] = e.message
      return redirect_to invoice_path invoice
    end
  end

  private

  def invoice_params
    params.require(:invoice).permit(:created_at)
  end

  def process_invoice(invoice)
    begin
      if InvoiceService.new.place(invoice)
        flash[:success] = t('order.placed.success')
        redirect_to invoice_path invoice
      else
        raise ProcessError, t('order.create.failure')
      end
    rescue ProcessError => e
      Raven.capture_exception(e.message, transaction: 'Place order')
      flash[:error] = e.message
      return redirect_to cart_index_path
    end
  end
end
