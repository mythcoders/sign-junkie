# frozen_string_literal: true

module Admin
  class InvoicesController < AdminController
    def index
      @q = Invoice.includes(:customer).ransack(params[:q])
      @q.sorts = 'created_at desc' if @q.sorts.empty?
      @invoices = @q.result(distinct: true).page(params[:page])
    end

    def show
      @invoice = Invoice.includes(:items, :customer).find(params[:id])
    end
  end
end
