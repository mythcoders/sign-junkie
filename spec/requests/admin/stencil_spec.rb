# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminStencilController', type: :request do
  before do
    create_and_login_admin
  end

  describe 'get index' do
    it 'renders' do
      get '/admin/stencils'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'post create' do
    let!(:stencil) { create(:stencil) }

    it 'does not allow deplicates' do
      expect {
        post '/admin/stencils', params: { stencil: stencil }
      }.to change{Stencil.count}.by(0)
    end

    it 'allows duplicate names in different categories' do
      category = create(:stencil_category)
      expect {
        post '/admin/stencils', params: { stencil: { name: stencil.name, stencil_category_id: category.id } }
      }.to change{Stencil.count}.by(1)
    end
  end
end
