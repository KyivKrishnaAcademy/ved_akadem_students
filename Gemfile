source 'https://rubygems.org'

gem 'rails', '5.0.7'

gem 'redis-rails'

gem 'haml'
gem 'activerecord', '~> 5.0'
gem 'pg', '~> 0.21'
gem 'responders'

gem 'kaminari'

gem 'devise'
gem 'devise_token_auth', git: 'https://github.com/mpugach/devise_token_auth.git', branch: 'use_standart_AR_uniqueness_message'
gem 'global_phone'
gem 'pundit'
gem 'recaptcha', require: 'recaptcha/rails'

gem 'nested_form'
gem 'simple_form'

gem 'carrierwave', '0.10.0'
gem 'mini_magick'

gem 'axlsx'
gem 'prawn-rails'
gem 'prawn-templates'
gem 'mustache'

gem 'fast_blank'

gem 'redis-namespace'
gem 'sidekiq'
gem 'sidekiq-scheduler'

gem 'paper_trail', '~> 9.2'

gem 'tzinfo-data'

gem 'react_on_rails', '~> 3.0'

gem 'sentry-raven'

gem 'uglifier'

gem 'railties', '~> 5.0.7'

gem 'tilt', '~> 1.4.0'

gem 'rubyzip', '~> 0.9.9'

group :assets_builder, :development, :test do
  gem 'autoprefixer-rails'
  gem 'bootstrap-sass'
  gem 'coffee-rails'
  gem 'font-awesome-sass'
  gem 'jquery-ui-rails'
  gem 'momentjs-rails'
  gem 'sass-rails'
  gem 'sprockets-svg'
end

group :production, :development do
  gem 'newrelic_rpm'
  gem 'puma', '~> 5.0'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'capistrano', require: false
  gem 'haml-rails', '~> 1.0'
  gem 'letter_opener_web', '~> 1.3'
  gem 'meta_request'
end

group :development, :test do
  gem 'nokogiri', '~> 1.10.10'
  gem 'loofah', '~> 2.20.0'
  gem 'ffaker'
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-rails'

  gem 'factory_bot_rails', '~> 4.0'
  gem 'haml_lint', require: false
  gem 'rubocop', require: false
  gem 'rubocop-rspec'
  gem 'rubocop-rails', require: false
  gem 'ruby-lint', require: false
end

group :test do
  gem 'capybara'
  gem 'codeclimate-test-reporter', require: false
  gem 'database_cleaner', '~> 1.8'
  gem 'fuubar'
  gem 'poltergeist'
  gem 'rack_session_access'
  gem 'rails-controller-testing'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-given'
  gem 'rspec-rails', '~> 3.5'
  gem 'shoulda-matchers'
  gem 'selenium-webdriver'
end
