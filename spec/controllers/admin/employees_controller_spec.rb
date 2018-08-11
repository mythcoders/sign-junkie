# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::EmployeesController do
  before do
    create_and_login_user    
  end

  describe '#index' do
    it 'should show' do
      get 'index'
      @request.env["devise.mapping"] = Devise.mappings[:user]
      expect(response.status).to be 200
    end
  end

  describe '#new' do
    it 'should show' do
      get 'new'
      expect(response.status).to be 200
    end
  end

  describe '#create' do
    let(:emp_params) do
      {
        user: {
          first_name: 'A',
          last_name: 'B',
          email: 'me@you.com',
          password: 'dave1234!',
          role: 'employee'
        }
      }
    end

    it 'succeeds' do
      expect do
        post 'create', params: emp_params
      end.to change { User.count }.by(1)
    end
  end
end
