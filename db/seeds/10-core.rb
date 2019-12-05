# frozen_string_literal: true

puts 'Creating core values...'

TaxRate.create!(rate: BigDecimal('0.0725'), effective_date: Time.zone.now) unless TaxRate.all.any?

unless WorkshopType.any?
  WorkshopType.create!(name: 'Public',
                       active: true,
                       default_single_seat_allow: true,
                       default_reservation_allow: true,
                       default_reservation_allow_multiple: true,
                       default_reservation_cancel_minimum_not_met: false,
                       default_reservation_allow_guest_cancel_seat: false,
                       default_total_seats: 18,
                       default_reservation_price: BigDecimal('50.00'),
                       default_reservation_minimum: 4,
                       default_reservation_maximum: 11)

  WorkshopType.create!(name: 'Private',
                       active: true,
                       default_single_seat_allow: false,
                       default_reservation_allow: true,
                       default_reservation_allow_multiple: false,
                       default_reservation_cancel_minimum_not_met: true,
                       default_reservation_allow_guest_cancel_seat: true,
                       default_total_seats: 18,
                       default_reservation_price: BigDecimal('100.00'),
                       default_reservation_minimum: 12,
                       default_reservation_maximum: 18)
end
