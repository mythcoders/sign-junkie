# frozen_string_literal: true

class CustomerMailer < ApplicationMailer
  helper :application

  def gift_card
    @customer = User.find params[:customer_id]
    @gift_amount = params[:gift_amount]
    make_bootstrap_mail(to: "#{@customer.first_name} #{@customer.last_name} <#{@customer.email}>",
                        subject: 'Someone has bought you a gift card!',
                        template_name: 'gift_card')
  end

  def abandoned_cart
    @customer = User.find params[:customer_id]
    make_bootstrap_mail(to: "#{@customer.first_name} #{@customer.last_name} <#{@customer.email}>",
                        subject: 'You have items left in your cart!',
                        template_name: 'abandoned_cart')
  end
end
