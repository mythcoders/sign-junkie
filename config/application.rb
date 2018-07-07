require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SignJunkie
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.encoding = 'utf-8'
    config.time_zone = 'Eastern Time (US & Canada)'
    config.public_file_server.enabled
    config.autoload_paths += %W[#{config.root}/lib]
    config.require_master_key = true
    config.force_ssl = true unless Rails.env.development?

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
