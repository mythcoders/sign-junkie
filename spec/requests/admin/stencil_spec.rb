# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminStencilController', type: :request do
  before do
    create_and_login_admin
  end

  describe 'GET index' do
    it 'renders' do
      get '/admin/stencils'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST create' do
    let!(:stencil) { create(:stencil) }

    it 'does not allow duplicates' do
      pending "TODO: fix undefined method `permit' for '#<Stencil:0x0000558c8feb5a48>:String'"
      expect do
        post '/admin/stencils', params: { stencil: stencil }
      end.to change { Stencil.count }.by(0)
    end

    it 'allows duplicate names in different categories' do
      category = create(:stencil_category)
      expect do
        post '/admin/stencils', params: { stencil: { name: stencil.name, stencil_category_id: category.id } }
      end.to change { Stencil.count }.by(1)
    end
  end
end
