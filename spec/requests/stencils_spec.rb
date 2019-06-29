require 'rails_helper'

RSpec.describe 'StencilsController', type: :request do
  let!(:stencil) { create(:stencil) }

  describe 'get index' do
    it 'renders' do
      get '/stencils'
      expect(response).to have_http_status(:ok)
    end

    it 'contains stencil name' do
      get '/stencils'
      expect(response.body).to include(stencil.name)
    end

    it 'assigns @categories' do
      categories = StencilCategory.with_stencils
      get '/stencils'
      expect(assigns(:categories)).to eq(categories)
    end
  end
end