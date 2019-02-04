# frozen_string_literal: true

module Ares
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
          ['Deployer', Ares::SystemInfo.deployer],
          ['Deployed', Ares::SystemInfo.deploy_time],
          [nil, nil],
          ['Platform', RUBY_PLATFORM.to_s],
          ['DB Adapter', ActiveRecord::Base.connection.adapter_name],
          ['Ruby version', "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE})"],
          ['Rails version', Rails::VERSION::STRING],
          ['Bundler version', Bundler::VERSION]
        ].map { |info| '%-19s %s' % info }.join("\n") + "\n"
      end
    end
  end
end
