# frozen_string_literal: true

# Assists with booking reservations and notifying customers
class OrderService
  def process!(invoice)
    invoice.items.each do |item|
      if item.gift_card?
        create_credit item, invoice.customer
      elsif item.reservation?
        book_reservation item, invoice.customer
      else
        recipient = item.gifted_seat? ? find_or_create_recipient(item) : invoice.customer
        reserve_seat item, recipient
      end
    end
    InvoiceMailer.with(invoice: invoice).paid.deliver_now
    true
  end

  def cancel!(invoice)
    invoice.cancelable_items.each do |invoice_item|
      if invoice_item.reservation?
      else
        invoice_item.description.cancel_date = DateTime.now
        invoice_item.description.save!

        InvoiceMailer.with(invoice: invoice).canceled.deliver_now
        InvoiceMailer.with(invoice: invoice).canceled_admin.deliver_now
      end
    end
    true
  end

  private

  def book_reservation(invoice_item, host)
    reservation = Reservation.new(
      workshop_id: invoice_item.workshop_id,
      user_id: host.id,
      payment_plan: 'guest'
    )

    reservation.save!
  end

  def reserve_seat(invoice_item, user = nil)
    Seat.create!(
      item_description_id: invoice_item.description.id,
      workshop_id: invoice_item.workshop_id,
      prepped: false,
      notified: false,
      customer: user
    )
  end

  def create_credit(item, _user)
    recipient = find_or_create_recipient(item, :gift_card)
    recipient.credits << CustomerCredit.new(starting_amount: item.item_amount,
                                            balance: item.item_amount)
    recipient.save!

    InvoiceMailer.with(customer: recipient, gift_amount: item.nontaxable_amount).gift_card.deliver_now
  end

  def find_or_create_recipient(item, _action = :reserve_seat)
    recipient = User.find_by_email(item.email)
    if recipient.nil?
      recipient = User.invite!(email: item.email,
                               first_name: item.first_name,
                               last_name: item.last_name,
                               role: 'customer')
    end

    recipient
  end
end
