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

  create_file "config/initializers/recaptcha.rb", <<~'RUBY', force: true
    Recaptcha.configure do |config|
      config.site_key = ENV["RECAPTCHA_SITE_KEY"].presence || (defined?(Figaro) && Figaro.env.recaptcha_site_key rescue nil) || "dummy_site_key"
      config.secret_key = ENV["RECAPTCHA_SECRET_KEY"].presence || (defined?(Figaro) && Figaro.env.recaptcha_secret_key rescue nil) || "dummy_secret_key"
    end
  RUBY

  create_file "config/initializers/redis.rb", <<~'RUBY', force: true
    require "redis"

    redis_config = {
      url: ENV["REDIS_URL"] || (defined?(Figaro) && Figaro.env.redis_url rescue nil) || "redis://localhost:6379/0",
      ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE },
      connect_timeout: 5,
      reconnect_attempts: 3,
      driver: :hiredis
    }

    $redis = Redis.new(redis_config)
  RUBY

  create_file "config/initializers/prefixed_ids.rb", <<~'RUBY', force: true
    PrefixedIds.salt = ENV["PREFIXED_IDS_SALT"].presence || (defined?(Figaro) && Figaro.env.prefixed_ids_salt rescue nil) || "default_salt_key_123"
    PrefixedIds.minimum_length = 10
  RUBY

  create_file "config/initializers/flash_rails_messages_bootstrap.rb", <<~'RUBY', force: true
    module FlashRailsMessages
      class Base
        def close_element
          content_tag :button, type: "button", class: "close", "data-dismiss": "alert" do
            content_tag(:span, "&times;".html_safe, "aria-hidden": "true") +
              content_tag(:span, "Close", class: "sr-only")
          end
        end

        def alert_type_classes
          {
            success: "alert-success",
            notice: "alert-success",
            alert: "alert-danger",
            error: "alert-danger"
          }
        end

        def custom_alert_classes
          if options.fetch(:dismissible, false)
            "alert-dismissible"
          end
        end
      end
    end
  RUBY

  create_file "config/initializers/inflections.rb", <<~'RUBY', force: true
    # Be sure to restart your server when you modify this file.
  RUBY
end
