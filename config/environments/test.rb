# frozen_string_literal: true

Rails.application.configure do
  config.cache_classes = true
  config.eager_load = false

  config.log_level = :info

  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control': "public, max-age=#{1.hour.to_i}"
  }

  config.assets.compile = true
  config.assets.prefix = "assets_test"
  config.action_controller.asset_host = "file://#{::Rails.root}/public"
  config.serve_static_assets = true
  config.assets.js_compressor = :terser

  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.require_master_key = true
  config.action_dispatch.show_exceptions = false

  config.action_controller.allow_forgery_protection = false

  config.action_mailer.perform_deliveries = false
  config.action_mailer.default_url_options = {
    host: "http://sign-junkie.localhost"
  }

  config.active_support.deprecation = :stderr
end
