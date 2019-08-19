# frozen_string_literal: true

shared_checks = lambda do |ping|
  ping.check do
    true
  end

  ping.check :db do
    ActiveRecord::Base.connection.active?
  end
end

Rails.application.config.middleware.use Pinglish, path: '/_heartbeat', &shared_checks

Rails.application.config.middleware.use Pinglish, path: '/_ping' do |ping|
  shared_checks.call ping

  ping.check :branch do
    SystemInfo.branch
  end

  ping.check :version do
    SystemInfo.long_version
  end

  ping.check :release do
    SystemInfo.release
  end
end
