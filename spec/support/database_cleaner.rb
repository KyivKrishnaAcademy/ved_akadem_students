require 'database_cleaner'

RSpec.configure do |config|
  # Полная очистка базы перед началом тестов
  config.before(:suite) do
    DatabaseCleaner[:active_record].clean_with(:truncation)
  end

  # Использование стратегии транзакций для каждого теста
  config.before(:each) do
    DatabaseCleaner[:active_record].strategy = :truncation
    DatabaseCleaner.start
  end

  # Для JavaScript-тестов используется стратегия truncation
  config.before(:each, js: true) do
    DatabaseCleaner[:active_record].strategy = :truncation
  end

  # Завершение работы DatabaseCleaner
  config.after(:each) do
    DatabaseCleaner.clean
  end

  # Очистка Redis перед каждым тестом
  config.before(:each) do
    Sidekiq::Worker.clear_all
  end
end