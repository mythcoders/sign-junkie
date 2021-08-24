# frozen_string_literal: true

require "rails_helper"

RSpec.describe "OrdersController", type: :request do
  describe "GET index" do
    context "when not authenticated" do
      before do
        sign_out :user
      end

      it "redirects to login" do
        get invoices_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before do
        create_and_login_user
      end

      it "renders" do
        get invoices_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET show" do
    before do
      @current_user = create_and_login_user
    end

    let(:invoice) { create(:invoice, customer: @current_user) }

    it "renders" do
      get invoice_path invoice
      expect(response).to have_http_status(:ok)
    end

    context "on another users invoice" do
      let(:customer) { create(:customer) }
      let(:other_invoice) { create(:invoice, customer: customer) }

      it "results in a 401" do
        get invoice_path other_invoice
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
