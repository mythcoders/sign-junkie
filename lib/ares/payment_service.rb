# frozen_string_literal: true

module Ares
  # Handles communication with the Braintree API for processing card and PayPal payments.
  class PaymentService
    attr_reader :payment, :order, :gateway

    def initialize(order)
      env = Ares::PaymentService.env.to_sym
      @order = order
      @payment = Payment.build(@order)
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

    def self.tax_rate
      0.0725
    end

    def self.taxed?
      false
    end

    def new_token
      gateway.client_token.generate
    end

    def process(payment_nonce)
      result = post_payment(payment_nonce)
      if result.success?
        @payment.status = :authorized
        @payment.date_cleared = Time.now
        @payment.transaction_id = result.transaction.id
        return true
      else
        @payment.status = :failed
        Raven.capture_exception(result.message, transaction: 'Post Payment')
        return false
      end
    end

    private

    def post_payment(payment_nonce)
      @payment.date_posted = Time.now
      gateway.transaction.sale(
        payment_method_nonce: payment_nonce,
        amount: @order.total_due,
        tax_amount: @order.total_tax,
        order_id: @order.order_number,
        options: { submit_for_settlement: true }
      )
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
end
