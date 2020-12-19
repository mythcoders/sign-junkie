# frozen_string_literal: true

require_relative 'boot'
require 'active_model/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_text/engine'
require 'action_view/railtie'
require 'view_component/engine'
require 'pinglish'

Bundler.require(*Rails.groups)

module Apollo
  class Application < Rails::Application
    config.load_defaults 5.2 # Initialize generated Rails version

    config.encoding = 'utf-8'
    config.time_zone = 'Eastern Time (US & Canada)'
    config.public_file_server.enabled
    config.eager_load_paths += %W[#{config.root}/lib]
    config.eager_load_paths += %W[#{config.root}/app/services]
    # config.require_master_key = true

    # Storage
    config.active_storage.variant_processor = :mini_magick
    config.active_storage.routes_prefix = '/storage'

    # Logging
    config.lograge.enabled = true

    # Mailing
    config.action_mailer.delivery_method = :hermes
  end
end
