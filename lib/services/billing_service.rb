module Services
  class BillingService
    def build(amount, tax_amount)
      Payment.new(
        amount: amount
      )
    end

    def process!(payment)
      result = gateway.post_sale payment
      if result.success?
        payment.identifier = result.transaction.id
        payment.save!
        return true

        # todo: send receipt
      end

      Raven.capture_exception(result.message, transaction: 'Post Payment')
      false
    end

    def refund
      if gateway.get_status(@payment).include?('settled', 'settling')
        result = gateway.post_refund
        return true if result.success?
        Raven.capture_exception(result.message, transaction: 'Post Refund')
      else
        return void
      end
      false
    end

    def void
      if gateway.get_status(@gateway).include?('authorized', 'submitted_for_settlement', 'settlement_pending')
        result = gateway.post_void
        return true if result.success?
        Raven.capture_exception(result.message, transaction: 'Post Void')
      end
      false
    end

    private

    def gateway
      @gateway ||= Services::BraintreeService.new
    end

    def calc_refund(purchase_amount, start_date)
      diff = start_date - Time.now

      if diff >= 48.hours
        purchase_amount
      elsif diff < 48.hours && diff > 24.hours
        (purchase_amount / 2).round(2)
      else
        0.00
      end
    end
  end
end
