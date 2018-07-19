# frozen_string_literal: true

Rails.application.config.middleware.insert_after ActionDispatch::Static, Pinglish do |ping|
  ping.check do
    true
  end

  ping.check :app_name do
    SignJunkie::SystemInfo.name
  end

  ping.check :version do
    SignJunkie::SystemInfo.version
  end

  ping.check :branch do
    SignJunkie::SystemInfo.branch
  end

  ping.check :database do
    ActiveRecord::Base.connection
    ActiveRecord::Base.connected?
  end

  ping.check :email do
    true
  end

  ping.check :payment do
    true
  end
end
