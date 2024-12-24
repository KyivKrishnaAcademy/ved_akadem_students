require 'capybara/rspec'
require 'capybara/rails'
require 'selenium-webdriver'

Capybara.default_max_wait_time = 15

Capybara.register_driver :selenium_chrome_headless do |app|
  caps = Selenium::WebDriver::Remote::Capabilities.chrome(
    'chromeOptions' => {
      'args' => %w[headless disable-gpu no-sandbox disable-dev-shm-usage window-size=1920,1080]
    }
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: caps
  )
end

Capybara.javascript_driver = :selenium_chrome_headless

RSpec.configure do |config|
  config.include Capybara::DSL
end