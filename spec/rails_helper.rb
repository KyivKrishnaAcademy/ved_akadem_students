ENV['RAILS_ENV'] = 'test'

def not_blank?(obj)
  !obj.nil? && !obj.empty?
end

# Настройка покрытия кода
if not_blank?(ENV['CODECLIMATE_REPO_TOKEN'])
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
elsif not_blank?(ENV['COVERAGE'])
  require 'simplecov'
  SimpleCov.start 'rails'
end

require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'rack_session_access/capybara'
require 'pundit/rspec'
require 'carrierwave/test/matchers'
require 'sidekiq/testing'
require 'factory_bot_rails'
require 'capybara/rspec'

Sidekiq::Testing.inline!

# Проверка актуальности схемы базы данных
ActiveRecord::Migration.maintain_test_schema!

# Подключение дополнительных файлов
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

puts "\nDB configuration: #{Rails.configuration.database_configuration[Rails.env].pretty_inspect}"

RSpec.configure do |config|
  config.filter_rails_from_backtrace!
  config.infer_spec_type_from_file_location!

  # Подключение FactoryBot и других хелперов
  config.include FactoryBot::Syntax::Methods
  config.include HelperMethods

  # Настройка reCAPTCHA
  Recaptcha.configure do |cfg|
    cfg.site_key = '11111'
    cfg.secret_key = '22222'
  end

  # Настройка моков
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = false
  end
end