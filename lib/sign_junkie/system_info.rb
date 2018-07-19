module SignJunkie
  module SystemInfo
    PHASE = 'alpha1'.freeze
    IS_PRE = true

    class << self
      def name
        Rails.application.class.parent_name.underscore
      end

      def app_name
        self.name.humanize.titleize
      end

      def developer
        'MythCoders, LLC'
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
        IS_PRE
      end

      def environment
        s = "Instance Information\n"
        s << [
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
    end
  end
end

