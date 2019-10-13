# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :role }
  it { should validate_length_of(:first_name).is_at_most(50) }
  it { should validate_length_of(:last_name).is_at_most(50) }

  shared_examples 'employee user' do
    it 'is returned in employees scope' do
      expect(User.employees).to include(subject)
    end

    it 'has access to the admin portal' do
      expect(subject.astronaut?).to be true
    end
  end

  shared_examples 'non-operator user' do
    it 'does not allow upgrading users to be an operator' do
      expect(subject.may_upgrade_operator?).to be false
    end
  end

  context 'when a customer' do
    subject { create(:customer) }

    include_examples 'non-operator user'

    it 'is returned in #customers' do
      expect(User.customers).to include(subject)
    end

    it 'does not allow access to the admin portal' do
      expect(subject.astronaut?).to be false
    end

    context 'created within the last 24 hours' do
      it 'is returned in #recently_created' do
        expect(User.recently_created).to include(subject)
      end
    end

    context 'created more then 24 hours ago' do
      subject { create(:customer, created_at: Time.zone.now - 25.hours) }

      it 'is not returned in #recently_created' do
        expect(User.recently_created).to_not include(subject)
      end
    end
  end

  context 'when an employee' do
    subject { create(:employee) }

    include_examples 'employee user'
    include_examples 'non-operator user'
  end

  context 'when an admin' do
    subject { create(:admin) }

    include_examples 'employee user'
    include_examples 'non-operator user'
  end

  context 'when an operator' do
    subject { create(:operator) }

    include_examples 'employee user'

    it 'allows upgrading users to be an operator' do
      expect(subject.may_upgrade_operator?).to be true
    end
  end
end
