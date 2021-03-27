# frozen_string_literal: true

class BraintreeService < ApplicationService
  PaymentError = Class.new(StandardError)
  RefundError = Class.new(StandardError)
  VoidError = Class.new(StandardError)

  def initialize
    gateway_params = Rails.application.credentials.payment[ENV['PAYMENT_ENV'].to_sym]
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
      options: { submit_for_settlement: true }
    )

    log_failed_transaction_and_raise!(result, PaymentError) unless result.success?
    result
  end

  def post_refund(payment, amount)
    raise RefundError 'Incorrect refund method' if payment.gift_card?

    result = gateway.transaction.refund(payment.identifier, amount)
    log_failed_transaction_and_raise!(result, RefundError) unless result.success?

    result
  end

  def void!(payment)
    raise VoidError 'Unvoidable payment type' if payment.gift_card?

    result = gateway.transaction.void(payment.identifier)
    log_failed_transaction_and_raise!(result, VoidError) unless result.success?

    result
  end

  protected

  attr_reader :gateway

  # rubocop:disable Metrics/AbcSize
  def log_failed_transaction_and_raise!(result, error_klass)
    Sentry.set_extras transaction: result.transaction
    Sentry.set_extras parameters: result.params

    error_message = case result.transaction.status
                    when 'processor_declined'
                      Sentry.set_extras response_code: result.transaction.processor_response_code

                      result.transaction.processor_response_text
                    when 'settlement_declined'
                      Sentry.set_extras response_code: result.transaction.processor_settlement_response_code

                      result.transaction.processor_settlement_response_text
                    when 'gateway_rejected'
                      result.transaction.gateway_rejection_reason
                    else
                      result.errors.map(&:message).join(', ')
                    end

    Sentry.set_extras response_message: error_message
    Sentry.capture_message('Braintree Failure', level: :warning)
    raise error_klass, error_message
  end
  # rubocop:enable Metrics/AbcSize
end
