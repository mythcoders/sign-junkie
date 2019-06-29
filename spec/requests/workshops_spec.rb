require 'rails_helper'

RSpec.describe 'WorkshopsController', type: :request do
  describe 'get bookings' do
    it 'renders' do
      get '/workshops/bookings'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'get policies' do
    it 'renders' do
      get '/policies'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'get public' do
    it 'renders' do
      get '/workshops/public'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'get private' do
    it 'renders' do
      get '/workshops/private'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'get private_hostess' do
    it 'renders' do
      get '/private_hostess'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'get private_policies' do
    it 'renders' do
      get '/private_policies'
      expect(response).to have_http_status(:ok)
    end
  end
end