source 'https://rubygems.org'

gem 'rails', '5.0.0.1'

gem 'redis-session-store'

gem 'haml'
gem 'pg'
gem 'responders'

gem 'kaminari'

gem 'devise'
gem 'devise_token_auth', github: 'mpugach/devise_token_auth', branch: 'use_standart_AR_uniqueness_message'
gem 'global_phone'
gem 'pundit'
gem 'recaptcha', require: 'recaptcha/rails'

gem 'nested_form'
gem 'simple_form'

gem 'carrierwave', '2.1.1'
gem 'mini_magick'

gem 'axlsx'
gem 'prawn-rails'

gem 'fast_blank'

gem 'redis-namespace'
gem 'sidekiq'
gem 'sidekiq-scheduler'

gem 'paper_trail'

gem 'tzinfo-data'

gem 'react_on_rails', '~> 3.0'

gem 'sentry-raven'

group :assets_builder, :development, :test do
  gem 'autoprefixer-rails'
  gem 'bootstrap-sass'
  gem 'bootstrap3-datetimepicker-rails'
  gem 'coffee-rails'
  gem 'font-awesome-sass'
  gem 'jquery-ui-rails'
  gem 'momentjs-rails'
  gem 'sass-rails'
  gem 'sprockets-svg'
  gem 'uglifier'
end

group :production, :development do
  gem 'newrelic_rpm'
  gem 'puma'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'capistrano', require: false
  gem 'haml-rails'
  gem 'letter_opener'
  gem 'meta_request'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'ffaker'
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-rails'

  gem 'haml_lint', require: false
  gem 'rubocop', require: false
  gem 'ruby-lint', require: false
end

group :test do
  gem 'capybara'
  gem 'codeclimate-test-reporter', require: false
  gem 'database_cleaner'
  gem 'fuubar'
  gem 'poltergeist'
  gem 'rack_session_access'
  gem 'rails-controller-testing'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-given'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
end
