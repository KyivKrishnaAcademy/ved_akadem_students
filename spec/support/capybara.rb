require 'capybara/poltergeist'
require 'capybara/rspec'
require 'capybara/rails'

Capybara.default_max_wait_time = 15

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(
    app,
    debug: false,
    js_errors: false,
    window_size: [1300, 1000]
  )
end

Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|
  config.include Capybara::DSL
end
