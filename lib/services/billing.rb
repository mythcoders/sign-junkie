module Services
  class Billing

    def process
      result = gateway.post_sale
      if result.success?
        @payment.identifier = result.transaction.id
        return true
      end

      Raven.capture_exception(result.message, transaction: 'Post Sale')
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
      @gateway ||= Services.Braintree.new
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
