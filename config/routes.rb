# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'public#index', as: 'home'
  devise_for :users,
             path_prefix: 'security',
             controllers: {
               registrations: 'security/registrations'
             }
  get 'admin', to: redirect('admin/dashboard/index'), as: 'cp'
  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  namespace :admin do
    get 'dashboard/index', as: 'dashboard'
    get 'dashboard/about', as: 'about'
  end
end
