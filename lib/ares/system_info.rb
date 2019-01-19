module Ares
  module SystemInfo
    class << self
      def name
        Rails.application.class.parent_name.underscore
      end

      def app_name
        name.humanize.titleize
      end

      def developer
        'MythCoders, LLC'.freeze
      end

      def support_url
        'mailto:support@mythcoders.com'.freeze
      end

      def version
        Rails.root.join('VERSION').read.chomp
      end

      def branch
        Rails.root.join('BRANCH').read.chomp
      end

      def versioned_name
        "#{app_name} #{version}"
      end

      def prerelease?
        version.include? '-'
      end

      def phase
        prerelease? ? version.split('-').last : 'release'
      end

      def license
        s = "#{Ares::ClientInfo.owner}\n"
        s << "Licensed\n"
        s << '99/99/9999 - 99/99/9999'
        s
      end
    end
  end
end
