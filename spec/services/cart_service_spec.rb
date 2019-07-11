# frozen_string_literal: true

RSpec.describe CartService do
  context '#add' do
    context 'when adding a seat' do
      shared_examples 'failed attempt' do
        pending 'WIP'
        # it should throw an error
        # it should not increase count by 1
      end

      context 'and all params are present' do
        pending 'WIP'
        # it should increase count by 1
      end

      context 'and project_id is not present' do
        include_examples 'failed attempt'
      end

      context 'and stencil_id is not present' do
        include_examples 'failed attempt'
      end

      context 'and all agreements have not been checked' do
        include_examples 'failed attempt'
      end
    end
  end

  context '#remove' do
    # it should decrease count
  end

  # context `#empty` do
  #   let(:user) { create(:customer) }

  #   it 'should empty cart for user' do
  #     pending 'WIP'
  #   end

  #   it 'should empty cart by time' do
  #     pending 'WIP'
  #   end
  # end
end
