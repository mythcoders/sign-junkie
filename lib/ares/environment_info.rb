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
          ['Deploy', Ares::SystemInfo.deployer],
          ['Platform', RUBY_PLATFORM.to_s],
          ['DB Adapter', ActiveRecord::Base.connection.adapter_name],
          [nil, nil],
          ['Ruby version', "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE})"],
          ['Rails version', Rails::VERSION::STRING],
          ['Bundler version', Bundler::VERSION]
        ].map { |info| '%-19s %s' % info }.join("\n") + "\n"
      end

      def storage_bucket
        case current
        when :dev
          'mcdoc-dvstg-signjunkie'
        when :test
          'mcdoc-tsstg-signjunkie'
        when :qa
          'mcdoc-qastg-signjunkie'
        when :prod
          'mcdoc-pdstg-signjunkie'
        else
          raise "Invalid env #{current}"
        end
      end
    end
  end
end
