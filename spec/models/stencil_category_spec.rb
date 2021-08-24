# frozen_string_literal: true

require "rails_helper"

RSpec.describe StencilCategory, type: :model do
  it { should validate_presence_of :name }

  # describe 'parent category' do
  #   context 'when set to self' do
  #     before do
  #       subject.parent_id = subject.id
  #     end

  #     it 'should not be valid' do
  #       expect(subject).not_to be_valid
  #     end
  #   end
  # end
end
