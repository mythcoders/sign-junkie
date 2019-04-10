# frozen_string_literal: true

module EnvironmentInfo
  class << self
    def current
      case Rails.env
      when 'development'
        :dev
      when 'test'
        :test
      when 'qa'
        :qa
      when 'production'
        :prod
      end
    end

    def instance
      [
        [nil, nil],
        ['Environment', Rails.env],
        ['Branch', SystemInfo.branch],
        ['Deploy time', SystemInfo.deploy_time],
        ['Deployer', SystemInfo.deployer],
        [nil, nil],
        ['Platform', RUBY_PLATFORM.to_s],
        ['Database adapter', ActiveRecord::Base.connection.adapter_name],
        ['Ares version', SystemInfo.long_version],
        ['Bundler version', Bundler::VERSION],
        ['Rails version', Rails::VERSION::STRING],
        ['Ruby version', "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE})"]
      ].map { |info| '%-26s %s' % info }.join("\n") + "\n"
    end
  end
end
