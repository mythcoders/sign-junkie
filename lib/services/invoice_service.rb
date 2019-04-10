module Services
  class InvoiceService

    def build_from_cart(user, created_at = Time.now)
      tax_service = TaxService.new
      invoice = Invoice.new(user_id: user.id,
                            status: :draft,
                            due_date: Date.today,
                            created_at: created_at)

      Cart.for(user).as_of(invoice.created_at).each do |cart|
        item = InvoiceItem.new(description: cart.description,
                               quantity: cart.quantity,
                               pre_tax_amount: cart.price)

        tax_service.apply_tax! item
        invoice.items << item
      end

      invoice
    end

    def place(invoice, payment)
      ActiveRecord::Base.transaction do
        if invoice.save! &&
            invoice.reload &&
            post_payment(invoice, payment) &&
            empty_cart(invoice)
          invoice.status = :paid

          return invoice.save! && OrderService.new.process!(invoice)
        else
          Rails.logger.warn 'Invoice creation failed!'
          raise ActiveRecord::Rollback
        end
      end
      false
    end

    private

    def empty_cart(invoice)
      CartService.new.empty! invoice.customer, invoice.created_at
    end

    def post_payment(invoice, payment)
      payment.method = 'braintree'
      payment.invoice = invoice
      payment.amount = invoice.grand_total
      Services::BillingService.new.process! payment
    end
  end
end
