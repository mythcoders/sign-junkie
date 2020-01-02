# frozen_string_literal: true

class InvoiceService < ApplicationService
  def initialize(invoice)
    @invoice = invoice
  end

  def place!
    ActiveRecord::Base.transaction do
      process_items
      empty_cart
      post_payments

      if @invoice.save! && @invoice.reload
        @invoice.status = :paid
        @invoice.save!
      else
        Raven.capture_exception(@invoice, transaction: 'Invoice creation failed')

        raise ActiveRecord::Rollback
      end
    end

    send_emails
  rescue StandardError, ProcessError => e
    Raven.capture_exception(e)
    void_payments
    raise e
  end

  private

  def empty_cart
    CartService.new.empty! @invoice.customer, @invoice.created_at
  end

  def post_payments
    @invoice.payments.each do |payment|
      PaymentService.new.process! payment
    end
  end

  def void_payments
    @invoice.payments.each do |payment|
      if payment.gift_card?
        # do we want this to be cleaner and actually refunded back to the original credit?
        CustomerCredit.create!(customer: payment.invoice.customer,
                               starting_amount: payment.amount,
                               balance: payment.amount)
      else
        BraintreeService.new.post_refund(payment, payment.amount)
      end
    end
  end

  def process_items
    @invoice.items.each do |item|
      if item.gift_card?
        CustomerService.new.issue_gift_card(item, @invoice.customer)
      elsif item.reservation?
        ReservationService.new.book(item, @invoice.customer)
      else
        SeatService.new.reserve(item, @invoice.customer)
      end
    end
  end

  def send_emails
    InvoiceMailer.with(invoice_id: @invoice.id).receipt.deliver_later

    @invoice.items.each do |item|
      if item.gift_card?
        CustomerMailer.with(customer_id: item.recipient.id, gift_amount: item.item_amount).gift_card.deliver_later
      elsif item.reservation?
        ReservationMailer.with(reservation_id: item.reservation.id).placed.deliver_later
        # elsif item.gifted_seat?
        #   SeatMailer.with(seat_id: item.seat.id).invited.deliver_later
      end
    end
  end
end
