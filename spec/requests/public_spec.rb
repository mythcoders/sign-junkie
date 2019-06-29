require 'rails_helper'

RSpec.describe 'PublicController', type: :request do
  describe 'get index' do
    it 'renders' do
      get root_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'get about' do
    it 'renders' do
      get '/about'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'get contact' do
    it 'renders' do
      get '/contact'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'get faq' do
    it 'renders' do
      get '/faq'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'get waiver' do
    it 'renders' do
      get '/waiver'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'get how_it_works' do
    it 'renders' do
      get '/how_it_works'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'get gift_cards' do
    it 'renders' do
      get '/gift_cards'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'get my_account' do
    context 'when not authenticated' do
      it 'redirects to login' do
        get '/my_account'
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when authenticated' do
      before do
        create_and_login_admin
      end

      it 'renders' do
        get '/my_account'
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'get my_credits' do
    context 'when not authenticated' do
      it 'redirects to login' do
        get '/my_credits'
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when authenticated' do
      before do
        create_and_login_admin
      end

      it 'render' do
        get '/my_credits'
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'get policies' do
    it 'render' do
      get '/policies'
      expect(response).to have_http_status(:ok)
    end
  end
end