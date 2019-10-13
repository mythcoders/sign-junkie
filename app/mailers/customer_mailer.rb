# frozen_string_literal: true

class CustomerMailer < ApplicationMailer
  helper :application

  def gift_card
    @customer = params[:customer]
    @gift_amount = params[:gift_amount]
    make_bootstrap_mail(to: "#{@customer.first_name} #{@customer.last_name} <#{@customer.email}>",
                        subject: 'Someone has bought you a gift card!',
                        template_name: 'gift_card')
  end
end
