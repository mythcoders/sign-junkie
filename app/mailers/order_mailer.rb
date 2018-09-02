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
end
