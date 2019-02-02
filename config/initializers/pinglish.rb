# frozen_string_literal: true

Rails.application.config.middleware.insert_after ActionDispatch::Static, Pinglish do |ping|
  ping.check do
    true
  end

  ping.check :database do
    ActiveRecord::Base.connection.select_value('SELECT 1').to_s == "1"
  end

  ping.check :branch do
    Ares::SystemInfo.branch
  end
  ping.check :version do
    Ares::SystemInfo.long_version
  end

  ping.check :release do
    Ares::SystemInfo.release
  end

  unless Rails.env.production?
    ping.check :deployer do
      Ares::SystemInfo.deployer
    end

    ping.check :deployed_at do
      Ares::SystemInfo.deploy_time
    end
  end
end
