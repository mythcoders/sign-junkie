# frozen_string_literal: true

Rails.application.config.middleware.insert_after ActionDispatch::Static, Pinglish do |ping|
  ping.check do
    true
  end

  ping.check :database do
    ActiveRecord::Base.connection.select_value('SELECT 1').to_s == "1"
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
    ping.check :deployed_at do
      SystemInfo.deploy_time
    end

    ping.check :deployer do
      SystemInfo.deployer
    end
  end
end
