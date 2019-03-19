class BraintreeService
  attr_reader :gateway

  def initialize
    env = BraintreeService.env.to_sym
    @gateway = Braintree::Gateway.new(
      environment: env,
      merchant_id: merchant_id(env),
      public_key: public_key(env),
      private_key: private_key(env)
    )
  end

  def self.env
    ENV['PAYMENT_ENV']
  end

  def new_token
    gateway.client_token.generate
  end

  protected

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
