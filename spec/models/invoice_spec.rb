# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice, type: :model do
  it { should validate_presence_of :due_date }

  context 'when any items are present' do
    context 'and taxable' do
      context '#tax_total' do
      end

      context '#taxed?' do
      end
    end

    context 'and cancelable' do
      context '#cancelable_items' do
      end
    end

    context '#balance' do
    end

    context '#grand_total' do
    end

    context '#sub_total' do
    end
  end

  context 'when payments have been applied' do
    subject { create(:invoice) }
    let!(:payment) { create(:payment, invoice: subject) }

    context '#amount_paid' do
      it 'should reflect applied payments' do
        expect(subject.amount_paid).to eq(payment.amount)
      end
    end

    context '#balance' do
      it 'should reflect applied payments' do
        expect(subject.balance).to eq(payment.amount * -1)
      end
    end
  end
end
