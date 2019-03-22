module Services
  class Invoice

    def from_cart(user)

      tax_service = Service::Tax.new
      invoice = Invoice.new(user_id: user.id,
                            identifier: SecureRandom.uuid,
                            status: :draft,
                            due_date: Date.today,
                            created_at: Time.now)

      Cart.for(user).as_of(invoice.created_at).each do |item|
        item = InvoiceItem.new(description: item.description,
                               quantity: item.quantity,
                               pre_tax_amount: item.price)

        tax_service.apply_tax! item
        invoice.items << item
      end

      invoice
    end

    def place(invoice)
      ActiveRecord::Base.transaction do
        item.
        if initial_save_reload! &&
            process_payment(payment) &&
            empty_cart &&
            order_ready?
          mark_placed_and_notify(payment)
          return true
        else
          Rails.logger.warn 'order place failed!'
          raise ActiveRecord::Rollback
        end
      end
      false
    end

    private

  end
end
