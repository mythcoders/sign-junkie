# frozen_string_literal: true

Rails.application.configure do
  config.hosts << Apollo.env_url(protocol: false)
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true

  # if Rails.root.join('tmp/caching-dev.txt').exist?
  #   config.action_controller.perform_caching = true

  #   config.cache_store = :memory_store
  #   config.public_file_server.headers = {
  #     'Cache-Control': "public, max-age=#{2.days.to_i}"
  #   }
  # else

  # end

  config.cache_store = :redis_cache_store, {url: ENV["REDIS_URL"], namespace: ENV["REDIS_NAMESPACE"]}
  config.action_controller.perform_caching = true

  # config.action_mailer.perform_deliveries = false
  config.action_mailer.perform_caching = false
  config.action_mailer.preview_path = "#{Rails.root}/spec/mailer_previews"
  config.action_mailer.asset_host = "http://#{Apollo.env_url(protocol: false)}"
  config.action_mailer.default_url_options = {
    host: Apollo.env_url(protocol: false),
    protocol: "https://"
  }

  config.active_record.verbose_query_logs = true

  config.active_support.deprecation = :log
  config.active_storage.service = :local
  # config.active_storage.service = :amazon
  config.active_job.queue_adapter = :inline
  config.active_record.migration_error = :page_load

  config.assets.debug = false
  config.assets.quiet = true
  config.web_console.whiny_requests = false
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.view_component.preview_paths << "#{Rails.root}/spec/components/previews"
end
