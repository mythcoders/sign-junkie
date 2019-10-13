# frozen_string_literal: true

# Emails sent during the reservation experience
class ReservationMailer < ApplicationMailer
  helper :application

  before_action { @reservation = params[:reservation] }

  def placed
    make_bootstrap_mail(to: "#{@reservation.host.full_name} <#{@reservation.host.email}>",
                        subject: 'Your reservation has been confirmed!',
                        template_name: 'placed')
  end

  def ready_for_payment
    make_bootstrap_mail(to: "#{@reservation.host.full_name} <#{@reservation.host.email}>",
                        subject: 'Your reservation is ready for payment!',
                        template_name: 'ready_for_payment')
  end

  def voided
    admin = User.system_admin
    make_bootstrap_mail(to: "#{@reservation.host.full_name} <#{@reservation.host.email}>",
                        bcc: "#{admin.full_name} <#{admin.email}>",
                        subject: 'Your reservation was automatically voided',
                        template_name: 'voided')
  end

  def canceled
    admin = User.system_admin
    make_bootstrap_mail(to: "#{@reservation.host.full_name} <#{@reservation.host.email}>",
                        bcc: "#{admin.full_name} <#{admin.email}>",
                        subject: 'Your reservation was been canceled',
                        template_name: 'canceled')
  end
end
