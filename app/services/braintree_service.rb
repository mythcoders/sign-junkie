# frozen_string_literal: true

class BraintreeService < ApplicationService
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
      raise ProcessError, 'Unable to process payment'
    end

    result
  end

  def post_refund(payment, amount)
    return false unless payment.credit_card?

    result = gateway.transaction.refund(payment.identifier, amount)
    unless result.success?
      log_failed_braintree(result, 'post_refund')
      raise ProcessError, 'Unable to process refund'
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
    Raven.extra_context parameters: result.params
    Raven.extra_context errors: errors
    Raven.capture_exception(result.message, transaction: transaction)
 end
end
