# Assists with booking reservations and notifying customers
module Services
  class ReservationService
    def process!(invoice)
      invoice.items.each do |item|
        if item.description.reservation?
          book_reservation item, invoice.customer
        else
          reserve_seat item, invoice.customer, invoice
        end
      end
    end

    private

    def book_reservation(item, host)
      reservation = Reservation.new(
        workshop_id: item.description.workshop_id,
        user_id: host.id,
        payment_plan: 'guest'
      )

      item.description.seat_quantity.times do
        seat = ItemDescription.seat(item.description.workshop)
        reservation.seats << reserve_seat(seat)
      end

      reservation.save!
    end

    def reserve_seat(item, user = nil, invoice = nil)
      Seat.create!(
        workshop_id: item.description.workshop_id,
        description: item.description,
        identifier: SecureRandom.uuid,
        prepped: false,
        notified: false,
        customer: user,
        invoice: invoice
      )
    end
  end
end
