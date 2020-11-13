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
        ["#{SystemInfo.app_name} commit", SystemInfo.long_version],
        ["#{SystemInfo.app_name} modules", SystemInfo.modules],
        ['Environment', Rails.env],
        ['Branch', SystemInfo.branch],
        [nil, nil],
        ['Platform', RUBY_PLATFORM.to_s],
        ['Database', ActiveRecord::Base.connection.adapter_name],
        ['Bundler', "v#{Bundler::VERSION}"],
        ['Rails', "v#{Rails::VERSION::STRING}"],
        ['Ruby', "v#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE})"]
      ].map { |info| '%-17s %s' % info }.join("\n") + "\n"
    end

    def env_url(protocol: true)
      if ENV['GITLAB_ENVIRONMENT_URL'].present? && protocol
        ENV['GITLAB_ENVIRONMENT_URL'].gsub('HTTP', 'HTTPS').gsub('http', 'https')
      elsif ENV['GITLAB_ENVIRONMENT_URL'].present?
        ENV['GITLAB_ENVIRONMENT_URL'].split('//').last
      else
        'signjunkie.mythcoders.dev'
      end
    end
  end
end
