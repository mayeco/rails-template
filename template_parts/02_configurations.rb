def add_configurations
  puts "\n==> 2. Configuring Environments and Base Initializers..."

  environment "config.i18n.default_locale = :es"
  environment "config.time_zone = 'America/Santiago'"
  environment "config.middleware.use HtmlCompressor::Rack unless Rails.env.development?"

  environment "config.after_initialize do\n    Bullet.enable = true\n    Bullet.alert = true\n    Bullet.bullet_logger = true\n  end", env: "development"
  environment "config.action_mailer.delivery_method = :letter_opener_web", env: "development"
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }", env: "development"
  environment "config.mission_control.jobs.http_basic_auth_enabled = false", env: "development"

  environment "config.active_storage.service = :amazon", env: "production"
  environment "config.mission_control.jobs.http_basic_auth_enabled = false", env: "production"

  create_file ".ruby-gemset", "#{app_name}\n", force: true

  create_file "config/application.yml", <<~'YAML', force: true
    recaptcha_site_key: "dummy_site_key"
    recaptcha_secret_key: "dummy_secret_key"
    redis_url: "redis://localhost:6379/0"
    prefixed_ids_salt: "default_salt_key_123"
    google_client_id: "dummy_google_id"
    google_client_secret: "dummy_google_secret"
    facebook_app_id: "dummy_facebook_id"
    facebook_app_secret: "dummy_facebook_secret"
    azure_client_id: "dummy_azure_id"
    azure_client_secret: "dummy_azure_secret"
    heroku_app_name: "dummy_heroku_app_name"
    heroku_api_token: "dummy_heroku_api_token"
  YAML

  create_file "config/initializers/simple_form.rb", <<~'RUBY', force: true
    # frozen_string_literal: true

    SimpleForm.setup do |config|
    end
  RUBY

  create_file "config/initializers/recaptcha.rb", <<~'RUBY', force: true
    # frozen_string_literal: true

    Recaptcha.configure do |config|
      config.site_key = Figaro.env.recaptcha_site_key
      config.secret_key = Figaro.env.recaptcha_secret_key
    end
  RUBY

  create_file "config/initializers/redis.rb", <<~'RUBY', force: true
    # frozen_string_literal: true

    require "redis"

    redis_config = {
      url: Figaro.env.redis_url,
      ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE },
      connect_timeout: 5,
      reconnect_attempts: 3,
      driver: :hiredis
    }

    $redis = Redis.new(redis_config)
  RUBY

  create_file "config/initializers/prefixed_ids.rb", <<~'RUBY', force: true
    PrefixedIds.salt = Figaro.env.prefixed_ids_salt
    PrefixedIds.minimum_length = 10
  RUBY

  create_file "config/initializers/flash_rails_messages.rb", <<~'RUBY', force: true
    # frozen_string_literal: true

    module FlashRailsMessages
      class Base
        def alert_element(type, message)
          content_tag :div, class: alert_classes(type), role: "alert" do
            message.html_safe
          end
        end

        def alert_classes(type)
          "p-4 mb-4 text-sm rounded-xl font-medium shadow-sm flex items-center justify-between #{alert_type_classes[type] || 'bg-slate-100 text-slate-800 border border-slate-200'}"
        end

        def alert_type_classes
          {
            success: "bg-emerald-50 text-emerald-800 border border-emerald-200",
            notice:  "bg-blue-50 text-blue-800 border border-blue-200",
            alert:   "bg-amber-50 text-amber-800 border border-amber-200",
            error:   "bg-red-50 text-red-800 border border-red-200"
          }
        end
      end
    end
  RUBY
end
