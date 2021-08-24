# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ProjectsController", type: :request do
  describe "GET index" do
    it "renders" do
      get "/projects"
      expect(response).to have_http_status(:ok)
    end
  end
end
