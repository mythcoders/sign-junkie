# frozen_string_literal: true

class InvoiceMailerPreview < ActionMailer::Preview
  def paid
    InvoiceMailer.with(invoice: Invoice.find(13)).paid
  end

  def canceled
    InvoiceMailer.with(invoice: Invoice.find(13)).canceled
  end

  def canceled_admin
    InvoiceMailer.with(invoice: Invoice.find(13)).canceled_admin
  end

  def gift_card
    InvoiceMailer.with(gift: ItemDescription.find(8), customer: User.find(19)).gift_card
  end
end
