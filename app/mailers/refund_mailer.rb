# frozen_string_literal: true

class RefundMailer < ApplicationMailer
  helper :application
  default from: "#{ClientInfo.name} <orders@#{ClientInfo.domain}>"

  before_action { @refund = Refund.find params[:refund_id] }

  def issued
    make_bootstrap_mail(to: "#{@refund.invoice.customer.full_name} <#{@refund.invoice.customer.email}>",
                        subject: "Refund issued for Order ##{@refund.invoice.identifier}",
                        template_name: 'issued')
  end
end
