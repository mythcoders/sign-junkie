# frozen_string_literal: true

FactoryBot.define do
  factory :invoice_item do
    invoice
    association :description, factory: :item_description
  end

  factory :seat_invoice_item, class: InvoiceItem do
    invoice
    association :description, factory: :seat_item
  end

  factory :reservation_invoice_item, class: InvoiceItem do
    invoice
    association :description, factory: :reservation_item
  end

  factory :gift_card_invoice_item, class: InvoiceItem do
    invoice
    association :description, factory: :gift_card_item
  end
end
