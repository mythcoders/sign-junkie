require 'rails_helper'

RSpec.describe DesignCategory, type: :model do
  subject { create(:design_category) }

  describe 'parent category' do
    context 'when set to self' do
      before do
        subject.parent_id = subject.id
      end

      it 'should not be valid' do
        expect(subject).not_to be_valid
      end
    end
  end
end
