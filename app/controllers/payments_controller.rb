# frozen_string_literal: true

class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_payment, only: %i[edit update transaction]
  before_action :set_client_token, only: %i[edit]

  def update
    if @payment.process(params)
      flash[:success] = t('order.update.success')
      redirect_to my_account_path
    else
      flash[:error] = t('order.payment.failure')
      redirect_to edit_order_payment_path @payment
    end
    Payment
  end

  private

  def set_payment
    logger.debug 'payment loaded and set'
    @payment = Payment.find(params[:id])
  end

  def set_client_token
    @client_token = Payment.new_client_token
  end
end
