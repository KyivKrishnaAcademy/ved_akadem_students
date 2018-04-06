source 'https://rubygems.org'

gem 'rails', '5.0.0.1'

gem 'redis-session-store'

gem 'haml'
gem 'pg'
gem 'responders'

gem 'kaminari'

gem 'devise'
gem 'devise_token_auth', github: 'mpugach/devise_token_auth', branch: 'use_standart_AR_uniqueness_message'
gem 'pundit'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'global_phone'

gem 'simple_form'
gem 'nested_form'

gem 'carrierwave', '0.10.0'
gem 'mini_magick'

gem 'axlsx'
gem 'prawn-rails'

gem 'fast_blank'

gem 'sidekiq'
gem 'redis-namespace'

gem 'paper_trail'

gem 'tzinfo-data'

gem 'react_on_rails', '~> 3.0'

gem 'sentry-raven'

group :assets_builder, :development, :test do
  gem 'bootstrap-sass'
  gem 'autoprefixer-rails'
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
  gem 'capistrano'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
  gem 'haml-rails'
  gem 'meta_request'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'ffaker'
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-doc'
  gem 'pry-rails'

  gem 'rubocop', require: false
  gem 'ruby-lint', require: false
  gem 'haml_lint', require: false
end

group :test do
  gem 'codeclimate-test-reporter', require: false
  gem 'rspec-rails'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-given'
  gem 'fuubar'
  gem 'poltergeist'
  gem 'capybara'
  gem 'shoulda-matchers'
  gem 'database_cleaner'
  gem 'rack_session_access'
  gem 'rails-controller-testing'
end
