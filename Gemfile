source 'https://rubygems.org'

# Default ruby version
ruby '2.1.0'

# Server related gems
gem 'foreman'
gem 'puma'

# Latest rails version
gem 'rails', '~> 4.0.3'

# Database-related gems
gem 'pg'

# Controller-related gems
gem 'before_actions'
gem 'inherited_resources' # This will be removed soon.


# Template-related gems
gem 'slim-rails'
gem 'active_decorator'
#gem 'best_in_place'  # Field live-edit


# Payment/Gateway related gems
gem 'mymoip'


# We will also use httparty with our workers
gem 'httparty'


# Model-validation related gems
gem "cpf_validator"                   # validate cpfs
gem 'validates_timeliness', '~> 3.0'  # validate dates/intervals


# Worker related gems
gem 'delayed_job_active_record' # to be removed
gem 'daemons'                   # to be removed


# Assets related gems
gem 'jquery-rails'
gem 'compass-rails'
gem 'compass-columnal-plugin' # to be removed
gem 'sass-rails'
gem 'uglifier'
gem "select2-rails"
gem 'foundation-rails', '~> 5.1.1.0'

# MeuRio UI related gems
gem 'gravatar_image_tag'
gem 'meurio_ui'


# Group related gems
group :production do
  gem 'newrelic_rpm' 
  gem 'rails_12factor'
end


group :development, :test do
  gem 'rspec-rails'
end

group :test do
  gem 'machinist'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'shoulda'
  gem 'cpf_cnpj'
end

