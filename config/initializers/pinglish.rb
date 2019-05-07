# frozen_string_literal: true

Rails.application.config.middleware.insert_after ActionDispatch::Static, Pinglish do |ping|
  ping.check do
    true
  end

  ping.check :database do
    ActiveRecord::Base.connection.active?
  end

  ping.check :branch do
    SystemInfo.branch
  end
  ping.check :version do
    SystemInfo.long_version
  end

  ping.check :release do
    SystemInfo.release
  end

  unless Rails.env.production?
    ping.check :build_time do
      SystemInfo.build_time
    end
  end
end
