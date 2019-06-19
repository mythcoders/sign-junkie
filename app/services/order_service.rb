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
    # InvoiceMailer.with(invoice: invoice).placed.deliver_now
    true
  end

  def cancel!(invoice)
    invoice.cancelable_items.each do |item|
      if item.reservation?
      else
        # TODO: Change this
        seat = Seat.find_by_invoice_item_id(item.id)
        seat.cancel_date = DateTime.now
        seat.save!
      end
    end
    # InvoiceMailer.with(invoice: invoice).canceled.deliver_now
    true
  end

  private

  def book_reservation(invoice_item, host)
    reservation = Reservation.new(
      workshop_id: invoice_item.workshop_id,
      user_id: host.id,
      payment_plan: 'guest'
    )

    item.description.seat_quantity.times do
      seat = ItemDescription.seat(item.description.workshop)
      reservation.seats << reserve_seat(seat)
    end

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

  def create_credit(item, user)
    recipient = find_or_create_recipient(item, :gift_card)
    recipient.credits << CustomerCredit.new(starting_amount: item.item_amount,
                                            balance: item.item_amount)
    recipient.save!
  end

  def find_or_create_recipient(item, action = :reserve_seat)
    recipient = User.find_by_email(item.email)
    if recipient.nil?
      # TODO: Invite customer with seat/workshop
      recipient = User.invite!(email: item.email,
                               first_name: item.first_name,
                               last_name: item.last_name,
                               role: 'customer')
    end

    recipient
  end
end
