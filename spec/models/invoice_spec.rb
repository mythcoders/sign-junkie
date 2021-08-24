# frozen_string_literal: true

require "rails_helper"

RSpec.describe Invoice, type: :model do
  it { should validate_presence_of :due_date }

  context "when any items are present" do
    context "and taxable" do
      describe "#tax_total" do
      end

      describe "#taxed?" do
      end
    end

    context "and cancelable" do
      describe "#cancelable_items" do
      end
    end

    describe "#balance" do
    end

    describe "#grand_total" do
    end

    describe "#sub_total" do
    end
  end

  context "when payments have been applied" do
    subject { create(:invoice) }
    let!(:payment) { create(:payment, invoice: subject) }

    describe "#amount_paid" do
      it "reflects applied payments" do
        expect(subject.amount_paid).to eq(payment.amount)
      end
    end

    describe "#balance" do
      it "reflects applied payments" do
        expect(subject.balance).to eq(payment.amount * -1)
      end
    end
  end
end
