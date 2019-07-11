# frozen_string_literal: true

class BillingService
  def process!(payment)
    Raven.extra_context payment: payment.attributes

    if payment.gift_card?
      post_gift_card(payment)
    else
      post_braintree(payment)
    end
  end

  def refund!(refund)
    refund.customer_credit = CustomerCredit.new(customer: refund.invoice.customer,
                                                starting_amount: refund.amount,
                                                balance: refund.amount)
    return true if refund.deduct!

    Raven.extra_context refund: refund.attributes
    Raven.capture_exception('Unable to process refund', transaction: 'Post Refund')
    raise ProcessError, 'Unable to process refund'
  end

  private

  def post_gift_card(payment)
    return true if CustomerCredit.deduct!(payment)

    Raven.capture_exception('Unable to deducet from gift card', transaction: 'Post Payment')
    raise ProcessError, 'Unable to deduct from gift card'
  end

  def post_braintree(payment)
    result = gateway.post_sale payment
    if result.success?
      payment.identifier = result.transaction.id
      payment.method = result.transaction.payment_instrument_type

      true
    else
      log_failed_braintree(result)
      raise ProcessError, 'Unable to process payment'
    end
  end

  def log_failed_braintree(result)
    errors = result.errors.map do |error|
      { attribute: error.attribute, code: error.code, message: error.message }
    end
    Raven.extra_context parameters: result.params
    Raven.extra_context errors: errors
    Raven.capture_exception(result.message, transaction: 'Post Payment')
  end

  def gateway
    @gateway ||= BraintreeService.new
  end
end
