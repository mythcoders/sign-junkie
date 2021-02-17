# frozen_string_literal: true

module InvoiceService
  class Processor
    def initialize(invoice)
      @invoice = invoice
    end

    def self.perform(invoice)
      new(invoice).perform
    end

    def perform
      ActiveRecord::Base.transaction do
        process_items
        post_payments

        if @invoice.save! && @invoice.reload
          Cart.empty! @invoice.customer, @invoice.created_at

          @invoice.status = :paid
          @invoice.save!
        else
          Sentry.capture_exception(@invoice, transaction: 'Invoice creation failed')

          raise ActiveRecord::Rollback
        end
      end

      send_emails
    rescue StandardError, ProcessError => e
      Sentry.capture_exception(e)
      void_payments
      raise e
    end

    private

    def post_payments
      @invoice.payments.each do |payment|
        PaymentService.new.process! payment
      end
    end

    def void_payments
      @invoice.payments.each do |payment|
        if payment.gift_card?
          # TODO: refunded back to the original credit
          CustomerCredit.create!(customer: payment.invoice.customer,
                                 starting_amount: payment.amount,
                                 balance: payment.amount)
        else
          BraintreeService.new.void! payment
        end
      end
    rescue Braintree::NotFoundError => e
      raise e if Rails.env.production?
    end

    def process_items
      @invoice.items.each do |item|
        if item.gift_card?
          GiftCardService::Booker.perform(item, @invoice.customer)
        elsif item.reservation?
          ReservationService::Booker.perform(item, @invoice.customer)
        else
          SeatService::Booker.perform(item, @invoice.customer)
        end
      end
    end

    # rubocop:disable Metrics/AbcSize
    def send_emails
      InvoiceMailer.with(invoice_id: @invoice.id).receipt.deliver_later

      @invoice.items.each do |item|
        if item.gift_card?
          send_gift_card_email item
        elsif item.reservation?
          ReservationMailer.with(reservation_id: item.reservation.id).placed.deliver_later
        elsif item.gifted_seat? && should_notify_purchased_seat?
          SeatMailer.with(seat_id: item.seat.id).purchased.deliver_later
        end
      end
    end
    # rubocop:enable Metrics/AbcSize

    def send_gift_card_email(item)
      recipient = User.where('email ILIKE ?', item.owner.email).first

      CustomerMailer.with(customer_id: recipient.id, gift_amount: item.item_amount).gift_card.deliver_later
    end

    def should_notify_purchased_seat?
      item.guest_type == 'adult' || (item.guest_type == 'child' && item.owner.parent.email != @invoice.customer.email)
    end
  end
end
