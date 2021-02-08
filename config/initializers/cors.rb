# frozen_string_literal: true

return if ENV['ASSETS_PRECOMPILE'].present?

Rails.application.config.middleware.insert_before ActionDispatch::Static, Rack::Cors do
  allow do
    origins '*'

    resource '/assets/*', headers: :any, methods: %i[get options]
    resource '/packs/*', headers: :any, methods: %i[get options]
  end
end
