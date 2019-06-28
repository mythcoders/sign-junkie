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
    it { should validate_presence_of :total_tickets }
    it { should validate_presence_of :is_public }
  end

  context 'when is private' do
    subject { create(:workshop, :private) }
    it { should validate_presence_of :reservation_price }

    it 'should be returned in #private_shops' do
      expect(Workshop.private_shops).to include(subject)
    end
  end

  context 'when is public' do
    subject { create(:workshop) }

    it 'should be returned in #public_shops' do
      expect(Workshop.public_shops).to include(subject)
    end
  end
end
