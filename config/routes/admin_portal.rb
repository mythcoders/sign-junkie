# frozen_string_literal: true

module Routes
  module AdminPortal
    extend ActionDispatch::Routing::Concern

    def draw_routes
      namespace :admin do
        root to: "dashboard#index", as: "dashboard"

        get "about", as: "about", to: "dashboard#about"
        post "demo_data", as: "demo_data", to: "dashboard#demo_data"
        get "help", as: "help", to: "help#index"
        get "finances", as: "finances", to: "finances#index"
        delete "images/:id", to: "images#destroy", as: "delete_image"
        get "reports", as: "reports", to: "reports#index"
        match "reports/credit_balances", to: "reports#credit_balances", as: "credit_balances_report", via: %i[get post]
        match "reports/guest_list", to: "reports#guest_list", as: "guest_list_report", via: %i[get post]
        match "reports/new_customers", to: "reports#new_customers", as: "new_customers_report", via: %i[get post]
        match "reports/sales_tax", to: "reports#sales_tax", as: "sales_tax_report", via: %i[get post]

        resources :addons, concerns: [:image_attachable]
        resources :affirmations
        resources :announcements, except: %i[show]
        resources :colors
        resources :customer_credits, only: %i[index], as: "credits", path: "credits"
        resources :gallery_images
        resources :invoices
        resources :policies
        resources :projects, concerns: %i[cloneable image_attachable] do
          resources :project_addons, path: "addons", as: "addons"
        end
        resources :tax_periods, only: %i[index new edit create update destroy]
        resources :tax_rates, only: %i[index new edit create update destroy]
        resources :seats, only: %i[], concerns: [:cancelable] do
          post "remind", action: :remind, on: :member
        end
        resources :stencils
        resources :stencil_categories
        resources :users, as: "customers", path: "customers", controller: "customers" do
          post "remind_cart", action: :remind, on: :member
          post "resend_confirmation", action: :resend_confirmation, on: :member
          resources :customer_credits, only: %i[new edit create update destroy], as: "credits", path: "credits"
        end
        resources :users, as: "employees", path: "employees", controller: "employees"
        resources :refunds, only: %i[index]
        resources :reservations, only: %i[], concerns: [:cancelable] do
          post "forfeit", action: :forfeit, on: :member
        end
        resources :workshops, concerns: %i[cloneable image_attachable]
        resources :workshop_types
      end
    end
  end
end
