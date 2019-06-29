require 'rails_helper'

RSpec.describe 'AddonsController', type: :request do
  describe 'get index' do
    it 'renders' do
      get '/addons'
      expect(response).to have_http_status(:ok)
    end
  end
end