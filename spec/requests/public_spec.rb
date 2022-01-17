# frozen_string_literal: true

require "rails_helper"

RSpec.describe "PublicController", type: :request do
  describe "GET index" do
    it "renders" do
      get root_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET about" do
    it "renders" do
      get "/about"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET contact" do
    it "renders" do
      get "/contact"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET faq" do
    it "renders" do
      get "/faq"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET waiver" do
    it "renders" do
      get "/waiver"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET how_it_works" do
    it "renders" do
      get "/how_it_works"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET gift_cards" do
    it "renders" do
      get "/gift_cards"
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET my_account" do
    context "when not authenticated" do
      it "redirects to login" do
        get "/my_account"
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before do
        create_and_login_admin
      end

      it "renders" do
        get "/my_account"
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET my_credits" do
    context "when not authenticated" do
      it "redirects to login" do
        get "/my_credits"
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before do
        create_and_login_admin
      end

      it "render" do
        get "/my_credits"
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
