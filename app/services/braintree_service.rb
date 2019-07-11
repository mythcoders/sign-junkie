# frozen_string_literal: true

class BraintreeService
  def self.env
    ENV['PAYMENT_ENV']
  end

  def token
    @token ||= gateway.client_token.generate
  end

  def post_sale(payment)
    gateway.transaction.sale(
      payment_method_nonce: payment.auth_token,
      amount: payment.amount,
      options: { submit_for_settlement: true }
    )
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
end
