# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'public#index', as: 'home'
  devise_for :users,
             path_prefix: 'security',
             controllers: {
               registrations: 'security/registrations'
             }
  get 'admin', to: redirect('admin/dashboard/index'), as: 'admin'
  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  # customer accounts and order processing
  get 'my_account', to: 'public#my_account'
  resources :addresses
  resources :events, only: %i[index show]
  resources :cart, only: %i[index create update destroy]
  resources :orders, only: %i[index show edit create update] do
    resources :payments, only: %i[new create edit update], as: 'payments'
  end
  get 'orders/:id/receipt', to: 'orders#receipt', as: 'receipt'

  namespace :admin do
    get 'dashboard/index', as: 'dashboard'
    get 'dashboard/about', as: 'about'
    resources :audits, concerns: :paginatable, only: %i[index show]
    resources :events, concerns: :paginatable do
      post 'primary', as: 'set_primary'
      resources :images, only: %i[new create destroy]
    end
    get 'orders/code/:order_number', to: 'orders#code', as: 'order_by_code'
    resources :orders, concerns: :paginatable do
      resources :order_items, as: 'items', path: 'items'
      resources :order_notes, as: 'notes', path: 'notes'
    end
    resources :users, as: 'customers', path: 'customers',
                      controller: 'customers', concerns: :paginatable do
      resources :notes, only: %i[edit new create update destroy]
      resources :addresses, only: %i[edit new create update destroy]
    end
    resources :users, as: 'employees', path: 'employees',
                      controller: 'employees', concerns: :paginatable
  end
end
