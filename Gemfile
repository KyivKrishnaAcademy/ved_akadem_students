source 'https://rubygems.org'

gem 'rails', '4.2.4'

gem 'redis-session-store'

gem 'haml'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'pg'
gem 'responders', '~> 2.0'

gem 'kaminari'

gem 'devise'
gem 'devise_token_auth'
gem 'pundit'
gem 'recaptcha', require: 'recaptcha/rails'

gem 'simple_form', '3.1.0'
gem 'nested_form'

gem 'carrierwave', '0.10.0'
gem 'mini_magick'

gem 'axlsx'
gem 'prawn-rails'

gem 'jquery-ui-rails'
gem 'bootstrap-sass'
gem 'intl-tel-input-rails', '3.6.0.1'

gem 'momentjs-rails', '>= 2.8.1'
gem 'bootstrap3-datetimepicker-rails', '~> 4.0.0'

gem 'react_on_rails', '~> 3.0'
gem 'therubyracer', platforms: :ruby

gem 'sidekiq'

gem 'airbrake'

gem 'paper_trail', '~> 4.0.0.rc'

group :production, :development do
  gem 'puma'
  gem 'whenever', require: false
  gem 'newrelic_rpm'
end

group :development do
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'
  gem 'capistrano-nvm', require: false
  gem 'capistrano-npm', require: false
  gem 'capistrano-puma', require: false
  gem 'airbrussh', require: false
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
  gem 'haml-rails'
  gem 'web-console', '~> 2.0'
  gem 'meta_request'
  gem 'spring'
  gem 'spring-commands-rspec'
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
  gem 'codeclimate-test-reporter', require: nil
  gem 'rspec-rails'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-given'
  gem 'fuubar'
  gem 'poltergeist'
  gem 'capybara'
  gem 'shoulda-matchers'
  gem 'database_cleaner'
  gem 'rack_session_access'
end
