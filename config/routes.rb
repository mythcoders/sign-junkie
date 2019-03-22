# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  concern :pageable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  # admin portal
  namespace :admin do
    root to: 'dashboard#index', as: 'dashboard'
    get 'about', as: 'about', to: 'dashboard#about'
    get 'settings', as: 'settings', to: 'settings#index'
    get 'finances', as: 'finances', to: 'finances#index'
    get 'reports', as: 'reports', to: 'reports#index'
    get 'reports/sales_tax', as: 'sales_tax_report'

    resources :audits, concerns: :pageable, only: %i[index show]
    resources :stencils, concerns: :pageable
    resources :projects, concerns: :pageable do
      resources :project_addons, path: 'addons', as: 'addons'
      resources :images, only: %i[new create destroy]
    end
    resources :invoices, concerns: :pageable
    resources :workshops, concerns: :pageable do
      resources :images, only: %i[new create destroy]
    end

    resources :users, as: 'customers', path: 'customers', controller: 'customers',
                      concerns: :pageable
    resources :users, as: 'employees', path: 'employees', controller: 'employees',
                      concerns: :pageable
    resources :tax_periods
    resources :tax_rates
  end

  # customer facing
  get 'tickets', to: 'public#tickets'
  get 'project', to: 'public#project'
  resources :cart, only: %i[index create update destroy]
  resources :invoices, only: %i[index show new]
  resources :reservations
  resources :workshops, only: %i[index show]

  root to: 'public#index', as: 'home'
end
