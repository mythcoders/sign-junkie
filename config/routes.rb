# frozen_string_literal: true

require "sidekiq/web"

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "security/registrations"
  }

  concern :cancelable do
    post "cancel", action: :cancel, on: :member
  end

  concern :cloneable do
    post "clone", action: :clone, on: :member
  end

  concern :image_attachable do
    get "images/new", action: :new_image, as: :new_image, on: :member
    post "images", action: :upload_images, as: :upload_images, on: :member
  end

  root to: "public#index"

  # customer facing
  get "my_account", to: "public#my_account"
  get "my_credits", to: "public#my_credits"
  get "gift_cards", to: "public#gift_cards"
  get "about", to: "public#about"
  get "contact", to: "public#contact"
  get "faq", to: "public#faq"
  get "waiver", to: "public#waiver"
  get "how_it_works", to: "public#how_it_works"
  get "projects/gallery", to: "projects#gallery", as: "gallery"
  get "privacy", to: "public#privacy"
  get "workshops/public", to: "workshops#public"
  get "workshops/private", to: "workshops#private"

  get "public_policies", to: "public#public_policies"
  get "public_hostess", to: "public#public_hostess"
  get "private_policies", to: "public#private_policies"
  get "private_hostess", to: "public#private_hostess"

  resources :addons, only: %i[index show]
  resources :cart, only: %i[index create destroy]
  resources :invoices, only: %i[index show new create], path: "orders"
  resources :projects, only: %i[index show] do
    get "addons", on: :member
    post "sidebar", on: :member
    get "stencils", on: :member
  end
  resources :reservations, only: %i[index show new create], concerns: :cancelable do
    resources :seats, only: %i[show edit new create update] do
      post "remind", action: :remind, on: :member
    end
  end
  resources :seats, only: %i[index show], concerns: :cancelable
  resources :stencils, only: %i[index show]
  resources :workshops, only: %i[index show] do
    get "seat", on: :member
    get "reservation", on: :member
    get "projects", on: :member
  end

  # admin portal
  namespace :admin do
    root to: "dashboard#index", as: "dashboard"

    authenticate :user, ->(u) { u.astronaut? } do
      mount Sidekiq::Web => "/sidekiq"
    end

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
    resources :announcements, except: %i[show]
    resources :customer_credits, only: %i[index], as: "credits", path: "credits"
    resources :gallery_images
    resources :invoices
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
# rubocop:enable Metrics/BlockLength
