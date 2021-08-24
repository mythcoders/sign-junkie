# frozen_string_literal: true

class DemoDataWorker
  include Sidekiq::Worker
  sidekiq_options retry: 1

  def perform
    load File.join(Rails.root, "db", "seed_helpers.rb")
    Dir[File.join(Rails.root, "db", "seeds", "optional", "*.rb")].sort.each do |seed|
      load seed
    end
  end
end
