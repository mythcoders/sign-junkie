# frozen_string_literal: true

class PaymentService < ApplicationService
  def process!(payment)
    Appsignal.tag_request payment: payment.attributes

    if payment.gift_card?
      deduct_credit(payment)
    else
      post_to_braintree(payment)
    end
  end

  private

  def deduct_credit(payment)
    return true if CustomerCredit.deduct!(payment)

    Appsignal.send_error('Unable to deducet from gift card', transaction: 'Post Payment')
    raise ProcessError, 'Unable to deduct from gift card'
  end

  def post_to_braintree(payment)
    result = gateway.post_sale payment
    payment.identifier = result.transaction.id
    payment.method = result.transaction.payment_instrument_type

    true
  end

  def gateway
    @gateway ||= BraintreeService.new
  end
end
