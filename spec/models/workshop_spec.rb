# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Workshop, type: :model do
  it { should validate_presence_of :name }

  context 'when is for sale' do
    subject { create(:workshop, :for_sale) }
    it { should validate_presence_of :purchase_start_date }
    it { should validate_presence_of :purchase_end_date }
    it { should validate_presence_of :start_date }
    it { should validate_presence_of :end_date }
  end

  # describe '.seat_purchaseable?' do
  #   it 'is false when not for sale' do
  #   end
  #
  #   it '' do
  #   end
  # end
  #
  # describe '.reservation_purchaseable?' do
  # end
  #
  # describe '.seats_available' do
  # end

  describe '.deleteable?' do
    subject { create(:bookable_workshop) }

    it 'is allowed when no seats or reservations' do
      expect(subject.deleteable?).to eq(true)
    end

    context 'when seats have already been purchased' do
      let!(:seat) { create(:seat, workshop: subject) }

      it 'is NOT allowed' do
        expect(subject.deleteable?).to eq(false)
      end

      context 'but they are cancled' do
        before do
          seat.update(cancel_date: Time.zone.now)
        end

        it 'is allowed' do
          expect(subject.deleteable?).to eq(true)
        end
      end

      context 'but are voided' do
        before do
          seat.update(void_date: Time.zone.now)
        end

        it 'is allowed' do
          expect(subject.deleteable?).to eq(true)
        end
      end
    end

    context 'when reservations have already been purchased' do
      let!(:reservation) { create(:reservation, workshop: subject) }

      it 'is NOT allowed' do
        expect(subject.deleteable?).to eq(false)
      end

      context 'but are cancled' do
        before do
          reservation.update(cancel_date: Time.zone.now)
        end

        it 'is allowed' do
          expect(subject.deleteable?).to eq(true)
        end
      end

      context 'but are voided' do
        before do
          reservation.update(void_date: Time.zone.now)
        end

        it 'is allowed' do
          expect(subject.deleteable?).to eq(true)
        end
      end
    end
  end
end
