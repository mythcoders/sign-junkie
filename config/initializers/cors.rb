# frozen_string_literal: true

return if ENV['CDN_URL'].nil? || ENV['ASSETS_PRECOMPILE'].present?

Rails.application.config.middleware.insert_before ActionDispatch::Static, Rack::Cors do
  allow do
    origins ENV['CDN_URL'], Apollo.env_url(protocol: false)

    resource '/assets/*', headers: :any, methods: %i[get options]
    resource '/packs/*', headers: :any, methods: %i[get options]
  end
end
