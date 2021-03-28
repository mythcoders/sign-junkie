# frozen_string_literal: true

module BraintreePayments
  extend ActiveSupport::Concern

  included do
    rescue_from BraintreeService::PaymentError, with: :handle_payment_error
  end

  private

  def set_client_token
    @client_token = BraintreeService.new_token
  end

  def handle_payment_error(exception)
    Sentry.capture_message exception.message, level: :warning
    flash[:error] = "Payment Error - #{exception.message}"

    redirect_to cart_index_path
  end
end
