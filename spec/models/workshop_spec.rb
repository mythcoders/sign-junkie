# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Workshop, type: :model do
  it { should validate_presence_of :name }

  context 'when for sale' do
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

  describe '#deleteable?' do
    let(:workshop) { create(:bookable_workshop) }
    subject { workshop.deleteable? }

    context 'when no seats or reservations' do
      it { is_expected.to be(true) }
    end

    context 'when seats have already been purchased' do
      let!(:seat) { create(:seat, workshop: workshop) }

      it { is_expected.to be(false) }

      context 'but they are canclled' do
        before do
          seat.update(cancel_date: Time.zone.now)
        end

        it { is_expected.to be(true) }
      end

      context 'but are voided' do
        before do
          seat.update(void_date: Time.zone.now)
        end

        it { is_expected.to be(true) }
      end
    end

    context 'when reservations have already been purchased' do
      let!(:reservation) { create(:reservation, workshop: workshop) }

      it { is_expected.to be(false) }

      context 'but are canclled' do
        before do
          reservation.update(cancel_date: Time.zone.now)
        end

        it { is_expected.to be(true) }
      end

      context 'but are voided' do
        before do
          reservation.update(void_date: Time.zone.now)
        end

        it { is_expected.to be(true) }
      end
    end
  end
end
