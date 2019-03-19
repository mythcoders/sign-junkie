class PaymentService
  attr_reader :payment, :gateway

  def initialize(payment)
    @payment = payment
    @gateway = BraintreeService.new
  end

  def process
    result = post_sale
    if result.success?
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
      options: { submit_for_settlement: true }
    )
  end

  def post_refund
    gateway.transaction.refund(@payment.identifier)
  end

  def post_void
    gateway.transaction.void(@payment.identifier)
  end
end
