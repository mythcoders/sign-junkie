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

  get 'my_account', to: 'public#index'

  namespace :admin do
    get 'dashboard/index', as: 'dashboard'
    get 'dashboard/about', as: 'about'
    resources :audits, concerns: :paginatable, only: %i[index show]
    resources :events, concerns: :paginatable do
      post 'primary', as: 'set_primary'
      resources :images, only: %i[new create destroy]
    end
    resources :users, as: 'customers', path: 'customers', controller: 'customers',
                      concerns: :paginatable do
      resources :notes, only: %i[edit new create update destroy]
      resources :addresses, only: %i[edit new create update destroy]
    end
    resources :users, as: 'employees', path: 'employees', controller: 'employees',
                      concerns: :paginatable
  end
end
