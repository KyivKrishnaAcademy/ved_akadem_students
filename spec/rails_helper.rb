ENV['RAILS_ENV'] ||= 'test'

def present?(obj)
  # NOTE Rails is not loaded yet
  !obj.nil? && !obj.empty?
end

if present?(ENV['CODECLIMATE_REPO_TOKEN'])
  require 'codeclimate-test-reporter'

  CodeClimate::TestReporter.start
elsif present?(ENV['COVERAGE'])
  require 'simplecov'

  SimpleCov.start 'rails'
end

require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'rack_session_access/capybara'

ActiveRecord::Migration.maintain_test_schema!

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.include FactoryGirl::Syntax::Methods
  config.include HelperMethods

  Recaptcha.configure do |cfg|
    cfg.public_key  = '11111'
    cfg.private_key = '22222'
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = false
  end
end
