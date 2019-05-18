class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :prepare_payment, only: %i[new create]

  def index
    @invoices = current_user.invoices.page(params[:page]).order(created_at: :desc)
  end

  def show
    @invoice = Invoice.includes(:items, :customer).find(params[:id])
  end

  def new
    @invoice = Services::InvoiceService.new.build_from_cart(current_user, params[:gift_cards])
    if @invoice.items.empty?
      flash[:error] = 'No items to checkout'
      redirect_to cart_index_path
    end

    @client_token = Services::BraintreeService.new.token
  end

  def create
    service = Services::InvoiceService.new
    @invoice = service.build_from_cart(current_user, create_params[:created_at])
    @payment.auth_token = params.fetch(:payment_method_nonce, nil)

    begin
      if service.place(@invoice, @payment)
        flash[:success] = t('order.placed.success')
        redirect_to invoice_path @invoice
      else
        raise Services::ProcessError, t('order.create.failure')
      end
    rescue Services::ProcessError => e
      flash[:error] = e.message
      return redirect_to cart_index_path
    end
  end

  def cancel
    service = Services::InvoiceService.new
    invoice = Invoice.find params[:id]
    begin
      if service.cancel(invoice)
        flash[:success] = t('order.placed.success')
        redirect_to invoice_path invoice
      else
        raise Services::ProcessError, t('order.create.failure')
      end
    rescue Services::ProcessError => e
      flash[:error] = e.message
      return redirect_to invoice_path invoice
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
end
