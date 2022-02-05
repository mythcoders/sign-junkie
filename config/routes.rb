# frozen_string_literal: true

Dir.glob(Rails.root.join("config", "routes", "**", "*.rb")).each { |f| load f }
require "sidekiq/web"

# routes are managed under config/routes
Rails.application.routes.draw do
  root to: "public#index"

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

  extend Routes::Legacy
  extend Routes::Public

  authenticate :user, ->(u) { u.astronaut? } do
    extend Routes::AdminPortal
  end

  authenticate :user, ->(u) { u.operator? } do
    mount Sidekiq::Web => "/admin/sidekiq"
  end
end
