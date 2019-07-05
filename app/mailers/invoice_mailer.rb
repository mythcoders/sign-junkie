# frozen_string_literal: true

# Emails sent during the ordering experience
class InvoiceMailer < ApplicationMailer
  helper :application

  before_action { @invoice = params[:invoice] }

  def paid
    mail(to: "#{@invoice.customer.full_name} <#{@invoice.customer.email}>",
         subject: 'Your order has been placed!',
         template_name: 'paid')
  end

  def canceled
    mail(to: "#{@invoice.customer.full_name} <#{@invoice.customer.email}>",
         subject: 'Your order was canceled',
         template_name: 'canceled')
  end

  def canceled_admin
    admin = User.system_admin
    mail(to: "#{admin.full_name} <#{admin.email}>",
         subject: "Order ##{@invoice.identifier} was canceled",
         template_name: 'canceled_admin')
  end

  def gift_card
    @customer = params[:customer]
    @gift_amount = params[:gift_amount]
    mail(to: "#{@customer.first_name} #{@customer.last_name} <#{@customer.email}>",
         subject: 'Someone has bought you a gift card!',
         template_name: 'gift_card')
  end
end
