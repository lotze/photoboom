ruby '3.1.4'
source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 7.1'
gem 'pg'

# Use SCSS for stylesheets
gem 'sassc'

# Use terser as compressor for JavaScript assets
gem 'terser'
gem 'sprockets-rails'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '>= 4.0.0'

gem 'twitter-bootstrap-rails'
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails'
gem 'therubyrhino'
gem 'font-awesome-rails'

# use the slick jquery carousel
gem 'jquery-slick-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# use postmark for sending emails
gem 'postmark-rails'

gem 'paperclip'
gem 'delayed_paperclip'
gem 'aws-sdk-s3'
gem 'rubyzip'
gem 'timezone' # Google Geocoding timezone lookup for getting default timezone for new games
gem 'activejob-retry'
gem 'delayed_paperclip'
# gem for making pdf from html
gem 'wicked_pdf'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '>= 1.2'

# Security ensuring
gem "kramdown", ">= 2.3.0"
gem "json", ">= 2.3.0"

gem 'dotenv-rails'

group :production do
  # gem for making pdf from html
  gem 'wkhtmltopdf-heroku'
end

group :development do
  gem 'seed_dump'
  gem 'foreman'
end

group :test do
  gem 'webmock'
  gem 'database_cleaner'
  gem 'rspec-core'
  gem 'rspec-rails'
  gem 'simplecov'
  gem 'fdoc'
  gem 'capybara'
  gem 'poltergeist'
end

group :development, :test do
  gem 'factory_girl_rails', require: false
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'omniauth', ">= 1.9.1"
# gem 'omniauth-facebook'
# gem 'omniauth-identity'
gem 'omniauth-google-oauth2'
# gem 'omniauth-rails_csrf_protection', '~> 0.1'

gem 'thin'

# Use ActiveModel has_secure_password
gem 'bcrypt', '>= 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
