# frozen_string_literal: true

Rails.application.config.middleware.insert_after ActionDispatch::Static, Pinglish do |ping|
  ping.check do
    true
  end

  unless Rails.env.production?
    ping.check :deployer do
      Ares::SystemInfo.deployer
    end
  end

  ping.check :version do
    Ares::SystemInfo.version
  end

  ping.check :release do
    Ares::SystemInfo.release
  end

  ping.check :branch do
    Ares::SystemInfo.branch
  end

  ping.check :database do
    ActiveRecord::Base.connection
    ActiveRecord::Base.connected?
  end
end
