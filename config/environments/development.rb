# frozen_string_literal: true

Rails.application.configure do
  config.cache_classes = false

  config.eager_load = false
  config.log_level = :debug

  config.consider_all_requests_local = true

  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: '127.0.0.1', port: 3000 }
  config.action_mailer.asset_host = 'http://example.com'
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.preview_path = "#{Rails.root}/spec/mailer_previews"

  config.active_support.deprecation = :log

  config.active_record.migration_error = :page_load

  config.assets.debug = false

  config.assets.quiet = true

  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
