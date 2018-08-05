module Ares
  module SystemInfo
    class << self
      def name
        Rails.application.class.parent_name.underscore
      end

      def app_name
        'Online Store' # name.humanize.titleize
      end

      def developer
        'MythCoders, LLC'
      end

      def support_url
        'mailto:incoming+ext/sign-jukie@git.mythcoders.net'
      end

      def owner
        'Sign Junkie'
      end

      def address_1
        'Street'
      end

      def address_2
        'Something, OH 43701'
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

      def environment
        case Rails.env
        when 'development'
          'dev'
        when 'quality-assurance'
          'qa'
        else
          Rails.env
        end
      end

      def instance
        [
          [nil, nil],
          ['Environment', Rails.env],
          ['Platform', RUBY_PLATFORM.to_s],
          ['DB Adapter', ActiveRecord::Base.connection.adapter_name],
          [nil, nil],
          ['Ruby version', "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE})"],
          ['Rails version', Rails::VERSION::STRING],
          ['Bundler version', Bundler::VERSION]
        ].map { |info| '%-19s %s' % info }.join("\n") + "\n"
      end

      def license
        s = "#{owner}\n"
        s << "Trial\n"
        s << '99/99/9999 - 99/99/9999'
        s
      end
    end
  end
end

