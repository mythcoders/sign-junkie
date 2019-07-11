# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminDashboardController', type: :request do
  context 'when authenticated' do
    context 'as an employee' do
      before do
        create_and_login_admin
      end

      describe 'GET admin' do
        it 'renders' do
          get '/admin'
          expect(response).to have_http_status(:ok)
        end

        it 'uses admin layout' do
          get '/admin'
          expect(response).to render_template(:admin)
        end
      end

      describe 'GET about' do
        it 'renders' do
          get '/admin/about'
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context 'as a customer' do
      before do
        create_and_login_user
      end

      describe 'GET index' do
        it 'redirects to login' do
          get '/admin'
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end
  end

  context 'when not authenticated' do
    before do
      sign_out :user
    end

    it 'redirects to login' do
      get '/admin'
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
