# frozen_string_literal: true

class CustomerMailer < ApplicationMailer
  helper :application

  before_action { @customer = User.find params[:customer_id] }

  def gift_card
    @gift_amount = params[:gift_amount]
    make_bootstrap_mail(to: "#{@customer.first_name} #{@customer.last_name} <#{@customer.email}>",
      subject: "Someone has bought you a gift card!",
      template_name: "gift_card")
  end

  def abandoned_cart
    make_bootstrap_mail(to: "#{@customer.first_name} #{@customer.last_name} <#{@customer.email}>",
      subject: "You have items left in your cart!",
      template_name: "abandoned_cart")
  end
end
