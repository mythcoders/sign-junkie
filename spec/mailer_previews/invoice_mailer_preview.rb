# frozen_string_literal: true

class InvoiceMailerPreview < ActionMailer::Preview
  def receipt
    InvoiceMailer.with(invoice_id: Invoice.find(2).id).receipt
  end
end
