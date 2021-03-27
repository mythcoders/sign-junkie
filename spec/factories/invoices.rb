# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    customer
    status { 'draft' }
    due_date { Time.zone.today }

    after(:build) do |invoice|
      invoice.items << build(:gift_card_invoice_item, invoice: invoice)
    end

    trait :paid do
      status { 'paid' }

      after(:create) do |invoice|
        create(:payment, invoice: invoice, amount: invoice.grand_total)
      end
    end
  end
end
