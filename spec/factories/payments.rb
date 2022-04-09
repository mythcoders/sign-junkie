# frozen_string_literal: true

FactoryBot.define do
  factory :payment do
    invoice
    add_attribute(:method) { "gift_card" }
    amount { Faker::Commerce.material }
    amount_refunded { 0.00 }

    factory :card_payment do
      add_attribute(:method) { "credit_card" }
      identifier { SecureRandom.hex(4) }

      factory :paypal_payment, parent: :card_payment do
        add_attribute(:method) { "paypal_account" }
      end
    end
  end
end
