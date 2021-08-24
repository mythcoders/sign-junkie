# frozen_string_literal: true

require "rails_helper"

RSpec.describe "AddonsController", type: :request do
  describe "GET index" do
    it "renders" do
      get "/addons"
      expect(response).to have_http_status(:ok)
    end
  end
end
