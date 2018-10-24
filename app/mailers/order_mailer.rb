# Emails sent during the ordering experience
class OrderMailer < ApplicationMailer
  default from: "#{Ares::SystemInfo.app_name} <orders@signjunkieworkshop.com>"
  helper :application

  before_action { @order = params[:order] }

  def placed
    mail(to: "#{@order.customer.full_name} <#{@order.customer.email}>",
         subject: 'Your order has been placed!',
         template_name: 'placed')
  end

  def fulfilled
    mail(to: "#{@order.customer.full_name} <#{@order.customer.email}>",
         subject: 'Your order has been processed!',
         template_name: 'fulfilled')
  end

  def closed
    mail(to: "#{@order.customer.full_name} <#{@order.customer.email}>",
         subject: 'Your order has been shipped!',
         template_name: 'shipped')
  end

  def canceled
    mail(to: "#{@order.customer.full_name} <#{@order.customer.email}>",
         subject: 'Your order was canceled',
         template_name: 'canceled')
  end
end
