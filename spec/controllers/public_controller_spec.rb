require 'rails_helper'

RSpec.describe PublicController, type: :controller do

  describe '#index' do
    it 'should show' do
      get 'index'
      expect(response.status).to be 200
    end
  end

end
