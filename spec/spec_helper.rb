require 'rubygems'
require 'rspec/given'
require 'paper_trail/frameworks/rspec'
require 'capybara/rspec'
require 'selenium-webdriver'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.raise_errors_for_deprecations!

  config.order = :random
  Kernel.srand config.seed

  # Customizing Capybara
  Capybara.app_host = 'http://localhost:3000'
  Capybara.default_host = 'http://localhost'
  Capybara.server_port = 3000
  Capybara.run_server = true

  Capybara.register_driver :headless_chrome do |app|
    options = Selenium::WebDriver::Chrome::Driver.new(args: ['headless'])
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument('--window-size=1920,1080')

    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end

  Capybara.javascript_driver = :headless_chrome

  config.before(:suite) do
    FileUtils.mkdir_p("#{Rails.root}/uploads/test")
  end

  config.after(:suite) do
    FileUtils.rm_rf(Dir["#{Rails.root}/uploads/test"])
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  config.after(:each) do
    Sidekiq.redis { |c| c.del(:class_schedule_with_people_mv_refresh) }
  end
end