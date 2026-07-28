def add_configurations
  puts "\n==> 2. Configuring Environments and Base Initializers..."

  environment "config.i18n.default_locale = Figaro.env.app_main_locale!.to_sym"
  environment "config.time_zone = Figaro.env.app_main_timezone!"
  environment "config.active_job.queue_adapter = :solid_queue"

  environment "config.after_initialize do\n    Bullet.enable = true\n    Bullet.bullet_logger = true\n    Bullet.rails_logger = true\n    Bullet.console = true\n  end", env: "development"
  environment "config.action_mailer.delivery_method = :letter_opener_web", env: "development"
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }", env: "development"
  environment "config.action_cable.allowed_request_origins = [%r{http://*}, %r{https://*}]", env: "development"
  environment "config.action_cable.disable_request_forgery_protection = true", env: "development"
  environment "config.mission_control.jobs.http_basic_auth_enabled = false", env: "development"

  create_file ".ruby-gemset", "#{app_name}\n", force: true

  append_to_file ".gitignore", "\n# Figaro configuration\n/config/application.yml\n" if File.exist?(".gitignore")

  create_file "config/application.yml.example", <<~'YAML', force: true
    app_main_locale: "es"
    app_main_timezone: "America/Santiago"
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
    mailer_sender: "no-reply@example.com"
    aws_access_key_id: "dummy_aws_access_key_id"
    aws_secret_access_key: "dummy_aws_secret_access_key"
    aws_region: "us-east-1"
    aws_bucket: "dummy_bucket"
    gcs_project: "dummy_gcs_project"
    gcs_credentials: "config/gcs.json"
    gcs_bucket: "dummy_gcs_bucket"
  YAML

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

  create_file "test/models/user_test.rb", <<~'RUBY', force: true
    # frozen_string_literal: true

    require "test_helper"

    class UserTest < ActiveSupport::TestCase
      test "valid user from factory" do
        user = FactoryBot.build(:user)
        assert user.valid?
      end
    end
  RUBY

  create_file "config/initializers/content_security_policy.rb", <<~'RUBY', force: true
    # frozen_string_literal: true

    Rails.application.configure do
      config.content_security_policy do |policy|
        policy.default_src :self, :https
        policy.font_src    :self, :https, :data, "https://cdn.jsdelivr.net"
        policy.img_src     :self, :https, :data
        policy.object_src  :none
        policy.script_src  :self, :https, :unsafe_inline, "https://www.google.com", "https://www.gstatic.com", "https://www.recaptcha.net", "https://recaptcha.net", "https://cdn.jsdelivr.net"
        policy.style_src   :self, :https, :unsafe_inline, "https://cdn.jsdelivr.net"
        policy.frame_src   :self, "https://www.google.com", "https://www.recaptcha.net", "https://recaptcha.net"
        policy.connect_src :self, :https, "ws:", "wss:", "http://localhost:*", "ws://localhost:*"
      end
    end
  RUBY

  create_file "config/initializers/simple_form.rb", <<~'RUBY', force: true
    # frozen_string_literal: true

    SimpleForm.setup do |config|
    end
  RUBY

  create_file "config/initializers/simple_form_tailwind.rb", <<~'RUBY', force: true
    # frozen_string_literal: true

    SimpleForm.setup do |config|
      config.button_class = 'my-2 bg-indigo-600 hover:bg-indigo-700 text-white font-medium text-sm py-2 px-4 rounded-lg shadow-sm transition'
      config.boolean_label_class = ''
      config.label_text = ->(label, required, _explicit_label) { "#{label} #{required}" }
      config.boolean_style = :inline
      config.item_wrapper_tag = :div
      config.include_default_input_wrapper_class = false
      config.error_notification_class = 'p-4 mb-4 text-sm rounded-xl font-medium shadow-sm bg-red-50 text-red-800 border border-red-200'
      config.error_method = :to_sentence
      config.input_field_error_class = 'border-red-500'
      config.input_field_valid_class = 'border-emerald-500'
      config.label_class = 'text-sm font-medium text-slate-700'

      config.wrappers :vertical_form, tag: 'div', class: 'mb-4' do |b|
        b.use :html5
        b.use :placeholder
        b.optional :maxlength
        b.optional :minlength
        b.optional :pattern
        b.optional :min_max
        b.optional :readonly
        b.use :label, class: 'block text-sm font-medium text-slate-700 mb-1', error_class: 'text-red-500'
        b.use :input,
              class: 'block w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm text-slate-800 leading-6 transition duration-150 ease-in-out', error_class: 'border-red-500', valid_class: 'border-emerald-500'
        b.use :full_error, wrap_with: { tag: 'p', class: 'mt-1 text-xs text-red-600' }
        b.use :hint, wrap_with: { tag: 'p', class: 'mt-1 text-xs text-slate-500' }
      end

      config.wrappers :vertical_boolean, tag: 'div', class: 'mb-4 flex items-start', error_class: '' do |b|
        b.use :html5
        b.optional :readonly
        b.wrapper tag: 'div', class: 'flex items-center h-5' do |ba|
          ba.use :input,
                 class: 'focus:ring-2 focus:ring-indigo-500 ring-offset-2 h-4 w-4 text-indigo-600 border-slate-300 rounded'
        end
        b.wrapper tag: 'div', class: 'ml-3 text-sm' do |bb|
          bb.use :label, class: 'block text-sm font-medium text-slate-700', error_class: 'text-red-500'
          bb.use :hint, wrap_with: { tag: 'p', class: 'block text-xs text-slate-500' }
          bb.use :full_error, wrap_with: { tag: 'p', class: 'block text-xs text-red-600' }
        end
      end

      config.wrappers :vertical_collection, item_wrapper_class: 'flex items-center',
                                            item_label_class: 'my-1 ml-3 block text-sm font-medium text-slate-700', tag: 'div', class: 'my-4' do |b|
        b.use :html5
        b.optional :readonly
        b.wrapper :legend_tag, tag: 'legend', class: 'text-sm font-medium text-slate-700 mb-1',
                               error_class: 'text-red-500' do |ba|
          ba.use :label_text
        end
        b.use :input,
              class: 'focus:ring-2 focus:ring-indigo-500 ring-offset-2 h-4 w-4 text-indigo-600 border-slate-300 rounded', error_class: 'text-red-500', valid_class: 'text-emerald-500'
        b.use :full_error, wrap_with: { tag: 'p', class: 'block mt-1 text-xs text-red-600' }
        b.use :hint, wrap_with: { tag: 'p', class: 'mt-1 text-xs text-slate-500' }
      end

      config.wrappers :vertical_file, tag: 'div', class: 'mb-4' do |b|
        b.use :html5
        b.use :placeholder
        b.optional :maxlength
        b.optional :minlength
        b.optional :readonly
        b.use :label, class: 'text-sm font-medium text-slate-700 block mb-1', error_class: 'text-red-500'
        b.use :input, class: 'w-full text-slate-700 px-3 py-2 border border-slate-300 rounded-lg shadow-sm focus:border-indigo-500 focus:ring-indigo-500 text-sm', error_class: 'text-red-500 border-red-500',
                      valid_class: 'text-emerald-500'
        b.use :full_error, wrap_with: { tag: 'p', class: 'mt-1 text-xs text-red-600' }
        b.use :hint, wrap_with: { tag: 'p', class: 'mt-1 text-xs text-slate-500' }
      end

      config.wrappers :vertical_select, tag: 'div', class: 'my-4', error_class: 'f', valid_class: '' do |b|
        b.use :html5
        b.optional :readonly
        b.use :label, class: 'text-sm font-medium text-slate-700 block mb-1', error_class: 'text-red-500'
        b.use :input, class: 'mt-1 block w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm text-slate-800', error_class: 'text-red-500', valid_class: 'text-emerald-500'
        b.use :full_error, wrap_with: { tag: 'p', class: 'mt-1 text-xs text-red-600' }
        b.use :hint, wrap_with: { tag: 'p', class: 'mt-1 text-xs text-slate-500' }
      end

      config.default_wrapper = :vertical_form

      config.wrapper_mappings = {
        boolean: :vertical_boolean,
        check_boxes: :vertical_collection,
        collection: :vertical_collection,
        file: :vertical_file,
        radio_buttons: :vertical_collection,
        select: :vertical_select
      }
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
