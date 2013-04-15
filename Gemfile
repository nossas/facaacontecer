source 'https://rubygems.org'
ruby '1.9.3'


gem 'rails', '~> 3.2.13'
gem 'inherited_resources'
gem 'slim-rails'
gem 'active_decorator'
gem 'coveralls', require: false

# Using mymoip gem to handle recurring BOLETO option
# for donation.
gem 'mymoip'

# This gem allow us to mantain only one dyno
# for jobs we want to run. So we don't to expend any money
# to run delayed jobs
#gem 'sucker_punch'

# We will also use httparty with our workers
gem 'httparty'

# An old gem to validate cpf
gem "cpf_validator"

# Validate dates
gem 'validates_timeliness', '~> 3.0'

group :development do
  gem 'better_errors'
  gem 'sqlite3'
  gem 'pry-rails'
end

group :production do
  gem 'pg'
  gem 'unicorn'
  gem 'newrelic_rpm'
  gem 'heroku-deflater'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'compass-rails'
  gem 'compass-columnal-plugin'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem "select2-rails"

  # Using asset_sync to send our CSS/HTML/images to Amazon
  # If you don't use heroku or Amazon, please comment the line
  # below
  # This also depends on running the command for your app:
  # heroku labs:enable user-env-compile
  gem 'asset_sync'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'mailcatcher'
end

group :test do
  gem 'selenium-webdriver'
  gem 'machinist'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'shoulda'
  gem 'jasmine'
  gem 'cpf_cnpj'
  
end

# jQuery
gem 'jquery-rails'
