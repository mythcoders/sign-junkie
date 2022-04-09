# frozen_string_literal: true

require "pathname"

module Apollo
  class << self
    def root
      Pathname.new(File.expand_path("..", __dir__))
    end

    def client
      "Sign Junkie, LLC"
    end

    def env_name
      case Rails.env
      when "development"
        "DEV"
      when "test"
        Rails.env.upcase
      when "review"
        "REV"
      else
        "PROD"
      end
    end

    def branch
      value = Rails.root.join("BRANCH").read.chomp
      if value.include?("refs/")
        value.sub!(%r{refs/(heads/|tags/)}, "")
      else
        value
      end
    end

    def support_url
      "https://mythcoders.com/support"
    end

    def env_url(protocol: true)
      if ENV["ENVIRONMENT_URL"].present? && protocol
        ENV["ENVIRONMENT_URL"].gsub("HTTP", "HTTPS").gsub("http", "https")
      elsif ENV["ENVIRONMENT_URL"].present?
        ENV["ENVIRONMENT_URL"].split("//").last
      else
        "wnlc.mythcoders.dev"
      end
    end

    def instance
      [
        ["#{SystemInfo.app_name} commit", SystemInfo.long_version],
        ["#{SystemInfo.app_name} modules", SystemInfo.modules],
        ["Environment", Rails.env],
        ["Branch", SystemInfo.branch],
        [nil, nil],
        ["Platform", RUBY_PLATFORM.to_s],
        ["Database", ActiveRecord::Base.connection.adapter_name],
        ["Bundler", "v#{Bundler::VERSION}"],
        ["Rails", "v#{Rails::VERSION::STRING}"],
        ["Ruby", "v#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE})"]
      ].map { |info| "%-17s %s" % info }.join("\n") + "\n"
    end

    def appsignal_env
      Rails.env.production? ? :production : :review
    end

    def appsignal_backend_key
      Rails.application.credentials.dig(:appsignal, :backend)
    end

    def appsignal_frontend_key
      Rails.application.credentials.dig(:appsignal, appsignal_env, :frontend)
    end
  end
end
