# frozen_string_literal: true

class InvoiceMailer < ApplicationMailer
  helper :application

  before_action { @invoice = params[:invoice] }

  def receipt
    make_bootstrap_mail(to: "#{@invoice.customer.full_name} <#{@invoice.customer.email}>",
                        subject: "Receipt for Order ##{@invoice.identifier}",
                        template_name: 'receipt')
  end
end
