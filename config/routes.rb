# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'public#index', as: 'home'
  get 'admin', to: redirect('admin/dashboard'), as: 'admin'

  devise_for :users
  concern :pageable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  # customer facing
  get 'tickets', to: 'public#tickets'
  get 'projects/:project_id', to: 'public#projects'
  resources :workshops, only: %i[index show]
  resources :cart, only: %i[index create update destroy]
  resources :orders, only: %i[index show new create edit update] do
    resources :order_items, path: 'items', only: %i[show create edit update] do
      post 'assign', to: 'order_items#assign'
    end
    get 'items_by_workshop/:workshop_id', to: 'order_items#by_workshop'
    post 'items/cancel', to: 'order_items#cancel', as: 'cancel_items'
  end

  # administration portal
  namespace :admin do
    get 'dashboard', as: 'dashboard', to: 'dashboard#index'
    get 'about', as: 'about', to: 'dashboard#about'
    get 'settings', as: 'settings', to: 'dashboard#settings'
    get 'finances', as: 'finances', to: 'dashboard#finances'
    get 'reports', as: 'reports', to: 'reports#index'
    get 'reports/sales_tax', as: 'sales_tax_report'

    resources :addons, concerns: :pageable
    resources :audits, concerns: :pageable, only: %i[index show]
    resources :design_categories, concerns: :pageable
    resources :designs, concerns: :pageable
    resources :projects, concerns: :pageable
    post 'orders/:id/cancel', to: 'orders#cancel', as: 'order_mark_canceled'
    resources :orders, concerns: :pageable do
      resources :order_items, as: 'items', path: 'items'
    end
    resources :workshops, concerns: :pageable do
      post 'project'
      post 'primary', as: 'set_primary'
      resources :images, only: %i[new create destroy]
    end

    resources :users, as: 'customers', path: 'customers',
              controller: 'customers', concerns: :pageable
    resources :users, as: 'employees', path: 'employees',
              controller: 'employees', concerns: :pageable
  end
end
