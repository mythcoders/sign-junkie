class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :prepare_payment, only: %i[new create]

  def show
    @invoice = Invoice.includes(:items, :user).find(params[:id])
  end

  def new
    @invoice = Services::InvoiceService.new.from_cart(current_user)
    @client_token = Services::BraintreeService.new.token
  end

  def create
    service = Services::InvoiceService.new
    @invoice = service.from_cart(current_user, create_params[:created_at])
    @payment.auth_token = params.fetch(:payment_method_nonce, nil)
    if service.place(@invoice, @payment)
      flash[:success] = t('order.placed.success')
      redirect_to invoice_path @invoice
    else
      invoice_create_error
    end
  end

  private

  def create_params
    params.require(:invoice).permit(:created_at)
  end

  def cancel_params
    params.require(:invoice).permit(order_item_ids: [])
  end

  def prepare_payment
    @payment = Payment.new
  end

  def invoice_create_error
    flash[:error] = t('order.create.failure')
    set_cart_total
    prepare_payment
    render 'new'
  end
end
