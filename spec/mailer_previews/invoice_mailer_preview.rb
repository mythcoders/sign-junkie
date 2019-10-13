# frozen_string_literal: true

class InvoiceMailerPreview < ActionMailer::Preview
  def receipt
    InvoiceMailer.with(invoice: Invoice.find(2)).receipt
  end
end
