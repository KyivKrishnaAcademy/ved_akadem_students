require 'capybara/poltergeist'
require 'capybara/rspec'
require 'capybara/rails'

include Warden::Test::Helpers

Warden.test_mode!

Capybara.default_wait_time = 5

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, { debug: false, window_size: [1300, 1000] })
end

Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|
  config.include Capybara::DSL

  config.after(:suite) do
    Warden.test_reset!
  end
end

def screenshot_page(file_name = 'Screenshot' << Time.now.strftime('%Y%m%d%H%M%S%L') << '.png')
  page.driver.render(File.join(Rails.root.join('tmp', 'capybara'), file_name))
end
