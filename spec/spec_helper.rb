# frozen_string_literal: true

require 'simplecov_env'

ENV['RAILS_ENV'] = 'test'

require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
require 'devise'
require 'view_component/test_helpers'

Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }
Dir[Rails.root.join('spec/initializers/**/*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run_when_matching :focus
  config.run_all_when_everything_filtered = true
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.disable_monkey_patching!

  config.order = :random
  Kernel.srand config.seed

  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include FactoryBot::Syntax::Methods
  config.include ViewComponent::TestHelpers, type: :component
end

ActiveRecord::Migration.maintain_test_schema!

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
