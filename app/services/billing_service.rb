class BillingService
  def process!(payment)
    if payment.gift_card?
      if CustomerCredit.deduct!(payment)
        return true
      else
        Raven.capture_exception('Unable to deducet from gift card', transaction: 'Post Payment')
        raise ProcessError, 'Unable to deduct from gift card'
      end
    else
      result = gateway.post_sale payment
      if result.success?
        payment.identifier = result.transaction.id
        payment.method = result.transaction.payment_instrument_type

        return true
      else
        Raven.capture_exception(result.message, transaction: 'Post Payment')
        raise ProcessError, 'Unable to process payment'
      end
    end
  end

  def refund!(refund)
    refund.customer_credit = CustomerCredit.new(customer: refund.invoice.customer,
                                                starting_amount: refund.amount,
                                                balance: refund.amount)
    refund.deduct!
  end

  private

  def gateway
    @gateway ||= BraintreeService.new
  end
end
