# frozen_string_literal: true

module Admin
  class RefundsController < AdminController
    def index
      @q = Refund.includes(:invoice).ransack(params[:q])
      @q.sorts = 'created_at desc' if @q.sorts.empty?
      @refunds = @q.result(distinct: true).page(params[:page])
    end
  end
end
