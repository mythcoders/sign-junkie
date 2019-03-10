module Admin
  class InvoicesController < AdminController
    def index
      @invoices = Invoice.page(params[:page]).per(10)
    end
  end
end
