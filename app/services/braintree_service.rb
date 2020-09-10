# frozen_string_literal: true

class BraintreeService < ApplicationService
  PaymentError = Class.new(StandardError)
  RefundError = Class.new(StandardError)
  VoidError = Class.new(StandardError)

  def self.env
    ENV['PAYMENT_ENV']
  end

  def token
    @token ||= gateway.client_token.generate
  end

  def post_sale(payment)
    result = gateway.transaction.sale(
      payment_method_nonce: payment.auth_token,
      amount: payment.amount,
      options: { submit_for_settlement: true }
    )

    unless result.success?
      log_failed_braintree(result, 'post_sale')
      raise PaymentError, result.errors.map(&:message).join(', ')
    end

    result
  end

  def post_refund(payment, amount)
    raise RefundError 'Incorrect refund method' if payment.gift_card?

    result = gateway.transaction.refund(payment.identifier, amount)
    unless result.success?
      log_failed_braintree(result, 'post_refund')
      raise RefundError, result.errors.map(&:message).join(', ')
    end

    result
  end

  def void!(payment)
    raise VoidError 'Unvoidable payment type' if payment.gift_card?

    result = gateway.transaction.void(payment.identifier)
    unless result.success?
      log_failed_braintree(result, 'post_void')
      raise VoidError, result.errors.map(&:message).join(', ')
    end

    result
  end

  protected

  def gateway
    env = BraintreeService.env.to_sym
    @gateway ||= Braintree::Gateway.new(environment: env,
                                        merchant_id: merchant_id(env),
                                        public_key: public_key(env),
                                        private_key: private_key(env))
  end

  def merchant_id(env)
    Rails.application.credentials.payment[env][:merchant_id]
  end

  def public_key(env)
    Rails.application.credentials.payment[env][:public_key]
  end

  def private_key(env)
    Rails.application.credentials.payment[env][:private_key]
  end

  def log_failed_braintree(result, transaction)
    errors = result.errors.map do |error|
      { attribute: error.attribute, code: error.code, message: error.message }
    end
    Appsignal.tag_request parameters: result.params
    Appsignal.tag_request errors: errors
    Appsignal.send_error(result.message, transaction: transaction)
  end
end
