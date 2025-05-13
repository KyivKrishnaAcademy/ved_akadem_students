ENV['RAILS_ENV'] = 'test'

def not_blank?(obj)
  # NOTE Rails is not loaded yet
  !obj.nil? && !obj.empty?
end

require 'simplecov'
SimpleCov.start 'rails' unless SimpleCov.running

require 'rails'
require 'spec_helper'
require_relative '../config/environment'
require 'rspec/rails'
require 'rack_session_access/capybara'  

Rails.application.reload_routes!

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

puts "\nDB configuration: #{Rails.configuration.database_configuration[Rails.env].pretty_inspect}"

RSpec.configure do |config|
  config.before(:suite) do
    Rails.application.load_tasks
    Rake::Task['db:migrate'].invoke
  end
  
  config.filter_rails_from_backtrace!
  config.infer_spec_type_from_file_location!

  config.include FactoryBot::Syntax::Methods
  config.include HelperMethods

  Recaptcha.configure do |cfg|
    cfg.site_key  = ENV['RECAPTCHA_SITE_KEY']
    cfg.secret_key = ENV['RECAPTCHA_SECRET_KEY']
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = false
  end
end
