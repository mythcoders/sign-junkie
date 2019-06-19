# frozen_string_literal: true

# Emails sent during the ordering experience
class InvoiceMailer < ApplicationMailer
  default from: "#{SystemInfo.app_name} <#{ClientInfo.contact_email}>"
  helper :application

  before_action { @invoice = params[:invoice] }

  def placed
    mail(to: "#{@invoice.customer.full_name} <#{@invoice.customer.email}>",
         subject: 'Your order has been placed!',
         template_name: 'placed')
  end

  def canceled
    mail(to: "#{@invoice.customer.full_name} <#{@invoice.customer.email}>",
         subject: 'Your order was canceled',
         template_name: 'canceled')
  end
end
