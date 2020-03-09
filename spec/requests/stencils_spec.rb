# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'StencilsController', type: :request do
  let!(:stencil) { create(:stencil) }

  describe 'GET index' do
    it 'renders' do
      get '/stencils'
      expect(response).to have_http_status(:ok)
    end

    it 'contains stencil name' do
      get '/stencils'
      expect(response.body).to include(stencil.name)
    end

    it 'assigns @categories' do
      categories = StencilCategory.includes(stencils: [{ image_attachment: :blob }])
      get '/stencils'
      expect(assigns(:categories)).to eq(categories)
    end
  end
end
