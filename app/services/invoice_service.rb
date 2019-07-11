# frozen_string_literal: true

class InvoiceService
  def place(invoice)
    ActiveRecord::Base.transaction do
      if post_payments(invoice) && empty_cart(invoice)
        invoice.status = :paid
        invoice.save! && invoice.reload
        return OrderService.new.process!(invoice)
      else
        Raven.capture_exception(invoice, transaction: 'Invoice creation failed')

        raise ActiveRecord::Rollback
      end
    end
    false
  end

  def cancel(invoice)
    ActiveRecord::Base.transaction do
      refund = Refund.new_from_invoice(invoice)

      return OrderService.new.cancel!(invoice) && BillingService.new.refund!(refund)
    end
    false
  end

  private

  def empty_cart(invoice)
    CartService.new.empty! invoice.customer, invoice.created_at
  end

  def post_payments(invoice)
    billing_service = BillingService.new
    invoice.payments.each do |payment|
      billing_service.process! payment
    end
  end
end
