require 'capybara/rspec'
require 'capybara/rails'
require 'selenium-webdriver'

# Настройка Capybara
Capybara.server = :puma, { Silent: true }

Capybara.default_max_wait_time = 10

Capybara.register_driver :chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless') # Режим без графического интерфейса
  options.add_argument('--no-sandbox') # Для работы в контейнерах
  options.add_argument('--disable-dev-shm-usage') # Для shared memory
  options.add_argument('--window-size=1400,1400') # Размер окна браузера
  options.add_argument('--disable-gpu') # Отключение GPU
  options.add_argument('--disable-extensions') # Отключение расширений
  options.add_argument('--disable-popup-blocking') # Отключает блокировку окон
  options.add_argument('--disable-notifications') # Отключает уведомления

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options,
    service: Selenium::WebDriver::Service.chrome(path: '/usr/bin/chromedriver')
  )
end

Capybara.javascript_driver = :chrome_headless

# Настройка RSpec
RSpec.configure do |config|
  # Использование Rack Test для тестов без JavaScript
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  # Использование headless Chromium для тестов с JavaScript
  config.before(:each, js: true, type: :system) do
    driven_by :chrome_headless
  end

  # Глобальная обработка алертов
  config.around(:each, js: true, type: :system) do |example|
    begin
      example.run
    rescue Selenium::WebDriver::Error::UnexpectedAlertOpenError
      alert = page.driver.browser.switch_to.alert
      alert.accept # Подтвердить alert
      retry # Повторить выполнение теста
    end
  end
end