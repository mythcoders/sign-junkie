# frozen_string_literal: true

# Handles communication with the Braintree API for processing card and PayPal payments.
class PaymentService
  attr_reader :payment, :gateway

  def initialize(payment)
    @payment = payment
    env = PaymentService.env.to_sym
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

  def process
    result = post_sale
    if result.success?
      @payment.method = result.transaction.type
      @payment.identifier = result.transaction.id
      return true
    end

    Raven.capture_exception(result.message, transaction: 'Post Sale')
    false
  end

  def refund
    if fetch_status.include?('settled', 'settling')
      result = post_refund
      return true if result.success?
      Raven.capture_exception(result.message, transaction: 'Post Refund')
    else
      return void
    end
    false
  end

  def void
    if fetch_status.include?('authorized', 'submitted_for_settlement', 'settlement_pending')
      result = post_void
      return true if result.success?
      Raven.capture_exception(result.message, transaction: 'Post Void')
    end
    false
  end

  private

  def fetch_status
    @fetch_status ||= gateway.transaction.find(@payment.identifier).status
  end

  def post_sale
    gateway.transaction.sale(
      payment_method_nonce: @payment.method_nonce,
      amount: @payment.amount,
      tax_amount: @payment.tax_amount,
      options: { submit_for_settlement: true },
      descriptor: {
        name: '',
        phone: '',
        url: ''
      }
    )
  end

  def post_refund
    gateway.transaction.refund(@payment.identifier)
  end

  def post_void
    gateway.transaction.void(@payment.identifier)
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
