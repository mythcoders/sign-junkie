# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'WorkshopsController', type: :request do
  describe 'GET bookings' do
    it 'renders' do
      get '/public_hostess'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET policies' do
    it 'renders' do
      get '/public_policies'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET public' do
    it 'renders' do
      get '/workshops/public'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET private' do
    it 'renders' do
      get '/workshops/private'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET private_hostess' do
    it 'renders' do
      get '/private_hostess'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET private_policies' do
    it 'renders' do
      get '/private_policies'
      expect(response).to have_http_status(:ok)
    end
  end
end
