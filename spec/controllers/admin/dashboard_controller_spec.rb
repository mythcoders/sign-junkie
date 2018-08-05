require 'rails_helper'

RSpec.describe Admin::DashboardController do
  context 'authenticated as an employee' do
    before do
      create_and_login_user
    end

    describe '#index' do
      it 'should show' do
        get 'index'
        expect(response.status).to be 200
      end

      it 'should use cp layout' do
        get 'index'
        expect(response).to render_template(:admin)
      end
    end

    describe '#about' do
      it 'should show' do
        get 'about'
        expect(response.status).to be 200
      end
    end
  end

  context 'not authenticated' do
    before do
      logout_user
    end

    it 'redirects to employee login' do
      get 'index'
      expect(response.status).to be 302
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
