# frozen_string_literal: true

require "simplecov"
require "active_support/core_ext/numeric/time"
require 'active_support/isolated_execution_state' if ActiveSupport::VERSION::MAJOR > 6

module SimpleCovEnv
  module_function

  def start!
    configure_profile
    configure_job

    SimpleCov.start
  end

  def configure_job
    SimpleCov.configure do
      if ENV["CI"]
        SimpleCov.at_exit do
          # In CI environment don't generate formatted reports
          # Only generate .resultset.json
          SimpleCov.result
        end
      end
    end
  end

  def configure_profile
    SimpleCov.configure do
      load_profile "test_frameworks"
      track_files "{app,lib}/**/*.rb"

      add_filter "/vendor/ruby/"
      add_filter "config/initializers/"
      add_filter "db/fixtures/"

      add_group "Configuration", "config"
      add_group "Controllers", "app/controllers"
      add_group "Helpers", "app/helpers"
      add_group "Libraries", "lib"
      add_group "Mailers", "app/mailers"
      add_group "Models", "app/models"
      add_group "Services", "app/services"
      add_group "Workers", %w[app/jobs app/workers]

      merge_timeout 365.days
    end
  end
end
