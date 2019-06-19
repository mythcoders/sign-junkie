class BillingService
  def process!(payment)
    if payment.gift_card?
      # todo: deduct payment amount from gift cards for the user
    else
      # todo: possible to set the amount a final time since we were doing it before?
      result = gateway.post_sale payment
      if result.success?
        payment.identifier = result.transaction.id
        payment.save!

        return true
      end
    end

    Raven.capture_exception(result.message, transaction: 'Post Payment')
    raise ProcessError, 'Unable to process payment'
  end

  def refund!(refund)
    refund.customer_credit = CustomerCredit.new(user: refund.invoice.customer,
                                                starting_amount: refund.amount,
                                                balance: refund.amount)
    refund.save!
  end

  private

  def void
    if gateway.get_status(@gateway).include?('authorized', 'submitted_for_settlement', 'settlement_pending')
      result = gateway.post_void

      return true if result.success?
    end
    false
  end

  def gateway
    @gateway ||= BraintreeService.new
  end
end
