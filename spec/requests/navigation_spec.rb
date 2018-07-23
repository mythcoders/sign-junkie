# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Navigation' do
  describe 'admin shorthandle' do
    subject { get '/admin' }

    it 'redirects to dashboard' do
      expect(subject).to redirect_to('/admin/dashboard/index')
    end
  end

  context 'when not authenticated' do
    it 'loads the public page' do
      get '/'
      expect(response.status).to eq(200)
    end

    it 'loads the admin dashboard' do
      get '/admin/dashboard/index'
      expect(response.status).to eq(200)
    end
  end
end
