# frozen_string_literal: true

SidekiqAlive.setup do |config|
  config.port = 5000
  config.path = '/_heartbeat'
end
