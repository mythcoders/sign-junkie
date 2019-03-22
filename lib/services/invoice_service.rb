module Services
  class InvoiceService

    def from_cart(user)
      tax_service = TaxService.new
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

    private

  end
end
