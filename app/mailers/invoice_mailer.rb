# frozen_string_literal: true

class InvoiceMailer < ApplicationMailer
  helper :application
  default from: "#{ClientInfo.name} <orders@#{ClientInfo.domain}>"

  before_action { @invoice = Invoice.find params[:invoice_id] }

  def receipt
    make_bootstrap_mail(to: "#{@invoice.customer.full_name} <#{@invoice.customer.email}>",
      subject: "Receipt for Order ##{@invoice.identifier}",
      template_name: "receipt")
  end
end
