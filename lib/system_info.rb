# frozen_string_literal: true

module SystemInfo
  class << self
    def app_name
      'Ares CRM'
    end

    def developer
      'MythCoders, LLC'
    end

    def support_url
      'mailto:incoming+mythcoders-sign-junkie-12022372-issue-@incoming.gitlab.com'
    end

    def support_key
      Rails.application.credentials[:support][:key]
    end

    def support_secret
      Rails.application.credentials[:support][:secret]
    end

    def release
      Rails.root.join('RELEASE').read.chomp
    end

    def build_time
      Rails.root.join('BUILD_TIME').read.chomp
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
