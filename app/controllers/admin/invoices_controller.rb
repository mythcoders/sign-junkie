# frozen_string_literal: true

module Admin
  class InvoicesController < AdminController
    def index
      @invoices = Invoice.order(created_at: :desc).page(params[:page]).per(10)
    end

    def show
      @invoice = Invoice.includes(:items, :customer).find(params[:id])
    end
  end
end
