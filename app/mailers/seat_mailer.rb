# frozen_string_literal: true

class SeatMailer < ApplicationMailer
  helper :application
  before_action { @seat = Seat.find params[:seat_id] }

  def invited
    mail(to: "#{@seat.customer.full_name} <#{@seat.customer.email}>",
         subject: "You've been invited to a workshop!",
         template_name: 'invited')
  end

  def ready_for_payment
    mail(to: "#{@seat.customer.full_name} <#{@seat.customer.email}>",
         subject: 'Your seat is ready for payment!',
         template_name: 'ready_for_payment')
  end

  def remind
    mail(to: "#{@seat.customer.full_name} <#{@seat.customer.email}>",
         subject: "Don't forget about your seat!",
         template_name: 'remind')
  end

  def registration_deadline
    mail(to: "#{@seat.customer.full_name} <#{@seat.customer.email}>",
         subject: "Don't forget about your seat!",
         template_name: 'registration_deadline')
  end

  def voided
    admin = User.system_admin
    mail(to: "#{@seat.customer.full_name} <#{@seat.customer.email}>",
         bcc: "#{admin.full_name} <#{admin.email}>",
         subject: 'Your seat has been automatically voided',
         template_name: 'voided')
  end

  def canceled
    admin = User.system_admin
    mail(to: "#{@seat.customer.full_name} <#{@seat.customer.email}>",
         bcc: "#{admin.full_name} <#{admin.email}>",
         subject: 'Your seat has been cancelled',
         template_name: 'canceled')
  end

  def purchased
    mail(to: "#{@seat.customer.full_name} <#{@seat.customer.email}>",
         subject: 'Someone has purchased a seat for you!',
         template_name: 'purchased')
  end
end
