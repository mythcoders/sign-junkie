# frozen_string_literal: true

# Emails sent during the ordering experience
class OrderMailer < ApplicationMailer
  default from: "#{SystemInfo.app_name} <orders@signjunkieworkshop.com>"
  helper :application

  before_action { @order = params[:order] }

  def placed
    @payment = @params[:payment]
    mail(to: "#{@payment.customer.full_name} <#{@payment.customer.email}>",
         subject: 'Your order has been placed!',
         template_name: 'placed')
  end

  def canceled
    mail(to: "#{@order.customer.full_name} <#{@order.customer.email}>",
         subject: 'Your order was canceled',
         template_name: 'canceled')
  end
end
