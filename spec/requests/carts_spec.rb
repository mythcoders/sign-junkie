require 'rails_helper'

RSpec.describe 'CartController', type: :request do
  describe 'get index' do
    context 'when not authenticated' do
      before do
        sign_out :user
      end

      it 'redirects to login' do
        get '/cart'
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when authenticated' do
      before do
        create_and_login_user
      end

      it 'renders' do
        get '/cart'
        expect(response).to have_http_status(:ok)
      end
    end
  end
end