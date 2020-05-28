# frozen_string_literal: true

module SystemInfo
  class << self
    def app_name
      'Apollo'
    end

    def developer
      'MythCoders, LLC'
    end

    def developer_url
      'https://www.mythcoders.com'
    end

    def support_url
      'https://mythcoders.atlassian.net/servicedesk/customer/portal/2'
    end

    def support_mail
      'support@mythcoders.com'
    end

    def support_key
      Rails.application.credentials.dig(:support, :key)
    end

    def support_secret
      Rails.application.credentials.dig(:support, :secret)
    end

    def modules
      %w[core customer_portal diy_workshops sales].join(',')
    end

    def release
      Rails.root.join('RELEASE').read.chomp
    end

    def long_version
      Rails.root.join('VERSION').read.chomp
    end

    def version
      long_version[0..6]
    end

    def branch
      value = Rails.root.join('BRANCH').read.chomp
      if value.include?('refs/')
        value.sub!(%r{refs/(heads/|tags/)}, '')
      else
        value
      end
    end

    def versioned_name
      "#{app_name} #{release}"
    end

    def prerelease?
      release.include? '-'
    end

    def phase
      prerelease? ? release.split('-').last : 'release'
    end

    def license
      s = "#{ClientInfo.owner}\n"
      s << "Licensed\n"
      s << '99/99/9999 - 99/99/9999'
      s
    end
  end
end
