def add_configurations
  puts "\n==> 2. Configuring Environments and Base Initializers..."

  environment "config.i18n.default_locale = :es"
  environment "config.time_zone = 'America/Santiago'"

  environment "config.after_initialize do\n    Bullet.enable = true\n    Bullet.bullet_logger = true\n    Bullet.rails_logger = true\n    Bullet.console = true\n  end", env: "development"
  environment "config.action_mailer.delivery_method = :letter_opener_web", env: "development"
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }", env: "development"
  environment "config.mission_control.jobs.http_basic_auth_enabled = false", env: "development"

  environment "config.mission_control.jobs.http_basic_auth_enabled = false", env: "production"

  create_file ".ruby-gemset", "#{app_name}\n", force: true

  append_to_file ".gitignore", "\n# Figaro configuration\n/config/application.yml\n" if File.exist?(".gitignore")

  create_file "config/storage.yml", <<~'YAML', force: true
    test:
      service: Disk
      root: <%= Rails.root.join("tmp/storage") %>

    local:
      service: Disk
      root: <%= Rails.root.join("storage") %>

    amazon:
      service: S3
      access_key_id: <%= Figaro.env.aws_access_key_id %>
      secret_access_key: <%= Figaro.env.aws_secret_access_key %>
      region: <%= Figaro.env.aws_region || "us-east-1" %>
      bucket: <%= Figaro.env.aws_bucket %>

    google:
      service: GCS
      project: <%= Figaro.env.gcs_project || "dummy_gcs_project" %>
      credentials: <%= Figaro.env.gcs_credentials || Rails.root.join("config/gcs.json") %>
      bucket: <%= Figaro.env.gcs_bucket || "dummy_gcs_bucket" %>
  YAML

  create_file "test/factories/users.rb", <<~'RUBY', force: true
    # frozen_string_literal: true

    FactoryBot.define do
      factory :user do
        sequence(:email) { |n| "user#{n}@example.com" }
        password { "password123" }
        confirmed_at { Time.current }
      end
    end
  RUBY

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
        private

        def default_alert_classes
          "p-4 mb-4 text-sm rounded-xl font-medium shadow-sm flex items-center justify-between"
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
