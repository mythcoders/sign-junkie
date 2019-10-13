# frozen_string_literal: true

class InvoiceService < ApplicationService
  def place!(invoice)
    ActiveRecord::Base.transaction do
      if post_payments(invoice) && empty_cart(invoice)
        invoice.status = :paid
        invoice.save! && invoice.reload

        invoice.items.each do |item|
          if item.gift_card?
            CustomerService.new.issue_gift_card(item, invoice.customer)
            CustomerMailer.with(customer: item.recipient, gift_amount: item.item_amount).gift_card.deliver_now
          elsif item.reservation?
            ReservationService.new.book(item, invoice.customer)
            ReservationMailer.with(reservation: item.reservation).placed.deliver_now
          else
            SeatService.new.reserve(item, invoice.customer)
          end
        end

        InvoiceMailer.with(invoice: invoice).receipt.deliver_now
        return true
      else
        Raven.capture_exception(invoice, transaction: 'Invoice creation failed')

        raise ActiveRecord::Rollback
      end
    end
    false
  end

  private

  def empty_cart(invoice)
    CartService.new.empty! invoice.customer, invoice.created_at
  end

  def post_payments(invoice)
    invoice.payments.each do |payment|
      PaymentService.new.process! payment
    end
  end
end
