# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'public#index', as: 'home'
  get 'admin', to: redirect('admin/dashboard/index'), as: 'admin'

  devise_for :users
  concern :pageable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  # customer facing
  get 'my_account', to: 'public#my_account'
  get 'projects/:project_id', to: 'public#projects'
  resources :addresses
  resources :workshops, only: %i[index show]
  resources :cart, only: %i[index create update destroy]
  resources :orders, only: %i[index show new create]
  post 'orders/ui', to: 'orders#ui', as: 'order_ui_update'
  get 'orders/:id/receipt', to: 'orders#receipt', as: 'receipt'
  post 'orders/:id/cancel', to: 'orders#cancel', as: 'order_mark_canceled'

  # administration portal
  namespace :admin do
    get 'dashboard/index', as: 'dashboard'
    get 'dashboard/about', as: 'about'
    get 'reports/index', as: 'reports'
    get 'reports/sales_tax', as: 'sales_tax_report'

    resources :addons, concerns: :pageable
    resources :audits, concerns: :pageable, only: %i[index show]
    resources :customizations, concerns: :pageable
    resources :projects, concerns: :pageable
    post 'orders/:id/fulfill', to: 'orders#fulfill', as: 'order_mark_fulfilled'
    post 'orders/:id/close', to: 'orders#close', as: 'order_mark_closed'
    post 'orders/:id/cancel', to: 'orders#cancel', as: 'order_mark_canceled'
    resources :orders, concerns: :pageable do
      resources :order_items, as: 'items', path: 'items'
      resources :order_notes, as: 'notes', path: 'notes'
    end
    resources :workshops, concerns: :pageable do
      post 'project'
      post 'primary', as: 'set_primary'
      resources :images, only: %i[new create destroy]
    end

    resources :users, as: 'customers', path: 'customers',
                      controller: 'customers', concerns: :pageable do
      resources :notes, only: %i[edit new create update destroy]
      resources :addresses, only: %i[edit new create update destroy]
    end
    resources :users, as: 'employees', path: 'employees',
                       controller: 'employees', concerns: :pageable
  end
end
