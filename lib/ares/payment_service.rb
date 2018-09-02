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

    attr_reader :payment, :gateway

    def initialize(payment)
      @payment = payment
      @gateway = new_braintree
    end

    def post(nonce)
      gateway.transaction.sale(
        amount: amount,
        payment_method_nonce: nonce,
        order_id: @payment.order.order_number,
        options: { submit_for_settlement: true }
      )
    end

    def process(result)
      if result.success?
        true
      else
        logger.debug result.message
        false
      end
    end

    def self.env
      ENV['BT_ENVIRONMENT']
    end

    def self.new_token
      new_braintree.client_token.generate
    end

    private

    def new_braintree
      env = PaymentService.env.to_sym
      Braintree::Gateway.new(
        environment: env,
        merchant_id: Rails.application.credentials.braintree[env][:merchant_id],
        public_key: Rails.application.credentials.braintree[env][:public_key],
        private_key: Rails.application.credentials.braintree[env][:private_key]
      )
    end
  end
end
