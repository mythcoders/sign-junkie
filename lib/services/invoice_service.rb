module Services
  class InvoiceService

    def from_cart(user, created_at = Time.now)
      tax_service = TaxService.new
      invoice = Invoice.new(user_id: user.id,
                            status: :draft,
                            due_date: Date.today,
                            created_at: created_at)

      Cart.for(user).as_of(invoice.created_at).each do |item|
        item = InvoiceItem.new(description: item.description,
                               quantity: item.quantity,
                               pre_tax_amount: item.price)

        tax_service.apply_tax! item
        invoice.items << item
      end

      invoice
    end

    def place(invoice, payment)
      ActiveRecord::Base.transaction do
        if invoice.save! &&
            invoice.reload &&
            empty_cart!(invoice) &&
            post_payment(invoice, payment)
          invoice.status = :paid
          return invoice.save!
        else
          Rails.logger.warn 'Invoice creation failed!'
          raise ActiveRecord::Rollback
        end
      end
      false
    end

    private

    def empty_cart(invoice)
      Services::CartService.new.empty! invoice.customer, invoice.created_at
    end

    def post_payment(invoice, payment)
      payment.invoice = invoice
      payment.amount = invoice.grand_total
      Services::BillingService.new.process! payment
    end
  end
end
