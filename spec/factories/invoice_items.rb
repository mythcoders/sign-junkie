# frozen_string_literal: true

FactoryBot.define do
  factory :invoice_item do
    invoice
  end

  factory :seat_invoice_item, class: InvoiceItem do
    invoice
    seat_item
  end

  factory :reservation_invoice_item, class: InvoiceItem do
    invoice
    reservation_item
  end

  factory :gift_card_invoice_item, class: InvoiceItem do
    invoice
    gift_card_item
  end
end
