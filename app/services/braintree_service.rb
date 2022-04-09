# frozen_string_literal: true

class BraintreeService < ApplicationService
  PaymentError = Class.new(StandardError)
  RefundError = Class.new(StandardError)
  VoidError = Class.new(StandardError)

  def initialize
    gateway_params = Rails.application.credentials.payment[ENV["PAYMENT_ENV"].to_sym]
    @gateway ||= Braintree::Gateway.new(gateway_params)

    super
  end

  def self.new_token
    new.send(:gateway).client_token.generate
  end

  def post_sale(payment)
    result = gateway.transaction.sale(
      payment_method_nonce: payment.auth_token,
      amount: payment.amount,
      options: {submit_for_settlement: true}
    )

    log_failed_transaction_and_raise!(result, PaymentError) unless result.success?
    result
  end

  def post_refund(payment, amount)
    raise RefundError "Incorrect refund method" if payment.gift_card?

    result = gateway.transaction.refund(payment.identifier, amount)
    log_failed_transaction_and_raise!(result, RefundError) unless result.success?

    result
  end

  def void!(payment)
    raise VoidError "Unvoidable payment type" if payment.gift_card?

    result = gateway.transaction.void(payment.identifier)
    log_failed_transaction_and_raise!(result, VoidError) unless result.success?

    result
  end

  protected

  attr_reader :gateway

  def log_failed_transaction_and_raise!(result, error_klass)
    tags = {
      parameters: result.params,
      details: extract_error_message_from_result(result)
    }

    if result.transaction.processor_response_code
      tags[:processor_response_code] = result.transaction.processor_response_code
    end

    if result.transaction.processor_settlement_response_code
      tags[:settlement_response_code] = result.transaction.processor_settlement_response_code
    end

    e = error_klass.new(tags[:details])
    Appsignal.set_error(e, tags)
    raise e
  end

  def extract_error_message_from_result(result)
    case result.transaction.status
    when "processor_declined"
      result.transaction.processor_response_text
    when "settlement_declined"
      result.transaction.processor_settlement_response_text
    when "gateway_rejected"
      result.transaction.gateway_rejection_reason
    else
      return result.errors.map(&:message).join(", ") if result.errors.any?

      "Processor Network Unavailable"
    end
  end
end
