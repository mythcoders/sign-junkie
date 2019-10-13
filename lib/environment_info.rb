# frozen_string_literal: true

module EnvironmentInfo
  class << self
    def current
      case Rails.env
      when 'production'
        :prod
      when 'development'
        :dev
      when 'review'
        :rev
      else
        Rails.env
      end
    end

    def analytics?
      ENV['APOLLO_ANALYTICS']
    end

    def errors?
      ENV['APOLLO_ERRORS']
    end

    def instance
      [
        [nil, nil],
        ["#{SystemInfo.app_name} version", SystemInfo.long_version],
        ["#{SystemInfo.app_name} modules", SystemInfo.modules],
        ['Environment', Rails.env],
        ['Branch', SystemInfo.branch],
        [nil, nil],
        ['Platform', RUBY_PLATFORM.to_s],
        ['Database adapter', ActiveRecord::Base.connection.adapter_name],
        ['Bundler version', Bundler::VERSION],
        ['Rails version', Rails::VERSION::STRING],
        ['Ruby version', "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE})"]
      ].map { |info| '%-26s %s' % info }.join("\n") + "\n"
    end
  end
end
