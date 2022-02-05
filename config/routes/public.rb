# frozen_string_literal: true

module Routes
  module Public
    extend ActionDispatch::Routing::Concern

    def draw_routes
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
      get "workshops/custom_order", to: "workshops#custom_order"

      resources :addons, only: %i[index show]
      resources :cart, only: %i[index create destroy]
      resources :invoices, only: %i[index show new create], path: "orders"
      resources :policies, only: %i[index show], param: :slug
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
    end
  end
end
