# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Navigation' do
  describe 'admin shorthandle' do
    it 'redirects to dashboard' do
      get '/admin'
      expect(response).to redirect_to('/admin/dashboard/index')
    end
  end
end
