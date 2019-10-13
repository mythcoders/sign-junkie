# frozen_string_literal: true

require 'sidekiq-ent/web'

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  mount Peek::Railtie => '/peek'
  devise_for :users

  concern :pageable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  concern :cancelable do
    post 'cancel', action: :cancel, on: :member
  end

  concern :cloneable do
    post 'clone', action: :clone, on: :member
  end

  concern :image_attachable do
    get 'images/new', action: :new_image, as: :new_image, on: :member
    post 'images', action: :upload_images, as: :upload_images, on: :member
  end

  root to: 'public#index'

  # admin portal
  namespace :admin do
    root to: 'dashboard#index', as: 'dashboard'

    authenticate :user, ->(u) { u.astronaut? } do
      mount Sidekiq::Web => '/sidekiq'
    end

    get 'about', as: 'about', to: 'dashboard#about'
    get 'help', as: 'help', to: 'help#index'
    get 'finances', as: 'finances', to: 'finances#index'
    delete 'images/:id', to: 'images#destroy', as: 'delete_image'
    get 'reports', as: 'reports', to: 'reports#index'
    get 'reports/sales_tax', as: 'sales_tax_report'

    resources :addons, concerns: [:image_attachable]
    resources :gallery_images
    resources :invoices
    resources :projects, concerns: %i[cloneable image_attachable] do
      resources :project_addons, path: 'addons', as: 'addons'
    end
    resources :tax_periods
    resources :tax_rates
    resources :seats, only: %i[], concerns: [:cancelable]
    resources :stencils
    resources :stencil_categories
    resources :users, as: 'customers', path: 'customers', controller: 'customers' do
      resources :customer_credits, only: %i[new edit create update destroy], as: 'credits', path: 'credits'
    end
    resources :users, as: 'employees', path: 'employees', controller: 'employees'
    resources :reservations, only: %i[], concerns: [:cancelable] do
      post 'forfeit', action: :forfeit, on: :member
    end
    resources :workshops, concerns: %i[cloneable image_attachable]
    resources :workshop_types
  end

  # customer facing
  get 'my_account', to: 'public#my_account'
  get 'my_credits', to: 'public#my_credits'
  get 'gift_cards', to: 'public#gift_cards'
  get 'about', to: 'public#about'
  get 'contact', to: 'public#contact'
  get 'faq', to: 'public#faq'
  get 'waiver', to: 'public#waiver'
  get 'how_it_works', to: 'public#how_it_works'
  get 'policies', to: 'workshops#public_policies'
  get 'projects/gallery', to: 'projects#gallery', as: 'gallery'
  get 'private_policies', to: 'workshops#private_policies'
  get 'private_hostess', to: 'workshops#hostess_policies'
  get 'workshops/public', to: 'workshops#public'
  get 'workshops/private', to: 'workshops#private'
  get 'workshops/bookings', to: 'workshops#hostess_public_policies'

  resources :addons, only: %i[index show]
  resources :cart, only: %i[index create destroy]
  resources :invoices, only: %i[index show new create], path: 'orders'
  resources :projects, only: %i[index show]
  resources :reservations, only: %i[index show new create], concerns: :cancelable do
    resources :seats, only: %i[show edit new create update] do
      post 'remind', action: :remind, on: :member
    end
  end
  resources :seats, only: %i[index show], concerns: :cancelable
  resources :stencils, only: %i[index show]
  resources :workshops, only: %i[index show]
end
# rubocop:enable Metrics/BlockLength
