# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'action_mailer/railtie'
# require 'active_job/railtie'
require 'action_cable/engine'
# require 'action_mailbox/engine'
require 'action_text/engine'
# require 'rails/test_unit/railtie'
require 'sprockets/railtie'
require 'view_component/engine'

require 'pinglish'

Bundler.require(*Rails.groups)

module Apollo
  class Application < Rails::Application
    require_dependency Rails.root.join('lib/apollo')

    config.load_defaults 5.2 # Initialize generated Rails version
    config.autoloader = :zeitwerk

    config.encoding = 'utf-8'
    config.time_zone = 'Eastern Time (US & Canada)'
    config.public_file_server.enabled
    config.eager_load_paths += %W[#{config.root}/lib]
    config.eager_load_paths += %W[#{config.root}/spec/mailer_previews]
    config.eager_load_paths += %W[#{config.root}/app/components]
    # config.require_master_key = true

    # Rake tasks ignore the eager loading settings, so we need to set the
    # autoload paths explicitly
    config.autoload_paths = config.eager_load_paths.dup

    # Storage
    config.active_storage.variant_processor = :mini_magick
    config.active_storage.routes_prefix = '/storage'

    # Logging
    config.lograge.enabled = true

    # Mailing
    config.action_mailer.delivery_method = :hermes
  end
end
