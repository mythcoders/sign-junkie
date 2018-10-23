# frozen_string_literal: true

module Ares
  class PaymentService
    TRANSACTION_SUCCESS_STATUSES = [
      Braintree::Transaction::Status::Authorizing,
      Braintree::Transaction::Status::Authorized,
      Braintree::Transaction::Status::Settled,
      Braintree::Transaction::Status::SettlementConfirmed,
      Braintree::Transaction::Status::SettlementPending,
      Braintree::Transaction::Status::Settling,
      Braintree::Transaction::Status::SubmittedForSettlement
    ].freeze

    attr_reader :payment, :order, :gateway

    def initialize(payment)
      @payment = payment
      @order = nil
      @gateway = new_braintree
    end

    def attempt(order, payment_nonce)
      @order = order
      was_successful = @payment.cash? ? handle_cash : post_payment(payment_nonce)
      successful_payment if was_successful
      was_successful
    end

    def self.tax_rate
      0.0725
    end

    def self.env
      ENV['PAYMENT_ENV']
    end

    def new_token
      gateway.client_token.generate
    end

    private

    def successful_payment
      @payment.date_posted = Time.now
    end

    def handle_cash
      @payment.status = :authorized
      true
    end

    def post_payment(payment_nonce)
      result = gateway.transaction.sale(
        payment_method_nonce: payment_nonce,
        amount: @payment.amount,
        tax_amount: @order.total_tax,
        shipping_amount: @order.total_shipping,
        order_id: @order.order_number,
        options: { submit_for_settlement: true }
      )
      if result.success?
        @payment.status = :authorized
        @payment.transaction_id = result.transaction.id
        true
      else
        Raven.capture_exception(result.message)
        false
      end
    end

    def new_braintree
      env = WHIZ::PaymentService.env.to_sym
      Braintree::Gateway.new(
        environment: env,
        merchant_id: Rails.application.credentials.payment[env][:merchant_id],
        public_key: Rails.application.credentials.payment[env][:public_key],
        private_key: Rails.application.credentials.payment[env][:private_key]
      )
    end
  end
end
