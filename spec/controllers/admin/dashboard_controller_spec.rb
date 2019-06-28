# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::DashboardController do
  context 'authenticated as an employee' do
    before do
      create_and_login_admin
    end

    describe '#index' do
      it 'should show' do
        get 'index'
        expect(response).to have_http_status(:ok)
      end

      it 'should use cp layout' do
        get 'index'
        expect(response).to render_template(:admin)
      end
    end

    describe '#about' do
      it 'should show' do
        get 'about'
        expect(response).to have_http_status(:ok)
      end
    end
  end

  context 'not authenticated' do
    before do
      sign_out :user
    end

    it 'redirects to employee login' do
      get 'index'
      expect(response.status).to be 302
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
