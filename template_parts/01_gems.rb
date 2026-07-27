def add_gems
  puts "\n==> 1. Configuring Gemfile with LATEST VERSION of all non-native gems..."

  gem "mission_control-jobs", "~> 1.1.0"
  gem "redis", "~> 5.4.1"
  gem "hiredis-client", "~> 0.30.1"

  # Devise & OmniAuth
  gem "devise", "~> 5.0.4"
  gem "omniauth", "~> 2.1.4"
  gem "omniauth-rails_csrf_protection", "~> 2.0.1"
  gem "omniauth-google-oauth2", "~> 1.2.2"
  gem "omniauth-facebook", "~> 11.0.0"
  gem "omniauth-microsoft_graph", "~> 2.2.0"

  # Internationalization
  gem "rails-i18n", "~> 8.1.0"
  gem "devise-i18n", "~> 1.16.0"

  # Utilities & UI
  gem "amazing_print", "~> 2.0.0"
  gem "aws-sdk-s3", "~> 1.228.1", require: false
  gem "google-cloud-storage", "~> 1.62.0", require: false
  gem "simple_form", "~> 5.4.1"
  gem "redcarpet", "~> 3.6.1"
  gem "figaro", "~> 1.3.0"
  gem "faraday", "~> 2.14.3"
  gem "prefixed_ids", "~> 1.8.1"
  gem "flash_rails_messages", "~> 2.3.0"
  gem "pagy", "~> 43.6.1"
  gem "view_component", "~> 4.12.0"
  gem "recaptcha", "~> 5.21.2"
  gem "htmlcompressor", "~> 0.4.0"

  gem_group :development do
    gem "bullet", "~> 8.1.3"
    gem "letter_opener_web", "~> 3.0.0"
    gem "pry", "~> 0.16.0"
    gem "hotwire-livereload", "~> 2.1.1"
    gem "debugbar", "~> 0.4.3"
  end

  gem_group :development, :test do
    gem "factory_bot_rails", "~> 6.5.1"
  end
end
