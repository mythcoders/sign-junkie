# frozen_string_literal: true

require 'sidekiq-ent/web'

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  root to: 'public#index'
  devise_for :users

  concern :pageable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  # admin portal
  namespace :admin do
    root to: 'dashboard#index', as: 'dashboard'

    authenticate :user, lambda { |u| u.can_cp? } do
      mount Sidekiq::Web => '/sidekiq'
    end

    get 'about', as: 'about', to: 'dashboard#about'
    get 'finances', as: 'finances', to: 'finances#index'
    get 'reports', as: 'reports', to: 'reports#index'
    get 'reports/sales_tax', as: 'sales_tax_report'

    resources :addons, concerns: :pageable
    resources :stencils, concerns: :pageable
    resources :stencil_categories, concerns: :pageable
    resources :projects, concerns: :pageable do
      resources :project_addons, path: 'addons', as: 'addons'
    end
    post 'projects/clone', to: 'projects#clone'
    resources :invoices, concerns: :pageable
    resources :workshops, concerns: :pageable
    post 'workshops/clone', to: 'workshops#clone'

    get 'workshops/:id/image', to: 'images#workshop', as: 'new_workshop_image'
    get 'projects/:id/image', to: 'images#project', as: 'new_project_image'
    get 'addons/:id/image', to: 'images#addon', as: 'new_addon_image'
    post 'workshops/:id/image', to: 'workshops#images', as: 'upload_workshop_image'
    post 'projects/:id/image', to: 'projects#images', as: 'upload_project_image'
    post 'addons/:id/image', to: 'addons#images', as: 'upload_addon_image'
    delete 'images/:id', to: 'images#destroy', as: 'delete_image'

    resources :users, as: 'customers', path: 'customers', controller: 'customers',
                      concerns: :pageable do
      resources :customer_credits, only: %i[new edit create update destroy],
                                   as: 'credits', path: 'credits'
    end
    resources :users, as: 'employees', path: 'employees', controller: 'employees',
                      concerns: :pageable
    resources :tax_periods
    resources :tax_rates

    get 'settings', as: 'settings', to: 'settings#index'
  end

  # customer facing
  get 'my_account', to: 'public#my_account'
  get 'my_credits', to: 'public#my_credits'
  get 'gift_cards', to: 'public#gift_cards'
  get 'about', to: 'public#about'
  get 'contact', to: 'public#contact'
  get 'faq', to: 'public#faq'
  # get 'reservation', to: 'reservations#reservation'
  # get 'reservation2', to: 'reservations#reservation2'
  # get 'reservation3', to: 'reservations#reservation3'
  get 'waiver', to: 'public#waiver'
  get 'how_it_works', to: 'public#how_it_works'
  get 'policies', to: 'workshops#public_policies'
  get 'projects/gallery', to: 'projects#gallery', as: 'gallery'
  get 'private_policies', to: 'workshops#private_policies'
  get 'private_hostess', to: 'workshops#hostess_policies'
  get 'workshops/public', to: 'workshops#public'
  get 'workshops/private', to: 'workshops#private'
  get 'workshops/bookings', to: 'workshops#coming_soon'

  resources :addons, only: %i[index show]
  resources :cart, only: %i[index create destroy]
  resources :invoices, only: %i[index show new create], path: 'orders'
  post 'invoices/:id/cancel', to: 'invoices#cancel', as: 'cancel_invoice'
  resources :projects, only: %i[index show]
  resources :stencils, only: %i[index show]
  resources :workshops, only: %i[index show]
end
# rubocop:enable Metrics/BlockLength
