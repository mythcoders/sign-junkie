# frozen_string_literal: true

module Admin
  class RefundsController < AdminController
    def index
      @refunds = Refund.order(created_at: :desc).page(params[:page]).per(10)
    end

    def show
      @refund = Refund.includes(:invoice, :customer).find(params[:id])
    end
  end
end
