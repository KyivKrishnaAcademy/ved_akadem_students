ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

if ENV['CODECLIMATE_REPO_TOKEN'].present?
  require 'codeclimate-test-reporter'

  CodeClimate::TestReporter.start
elsif ENV['COVERAGE'].present?
  require 'simplecov'

  SimpleCov.start 'rails'
end

require 'rack_session_access/capybara'

ActiveRecord::Migration.maintain_test_schema!

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.include FactoryGirl::Syntax::Methods
  config.include HelperMethods

  ReactOnRails::TestHelper.configure_rspec_to_compile_assets(config)

  Recaptcha.configure do |cfg|
    cfg.public_key  = '11111'
    cfg.private_key = '22222'
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = false
  end
end
