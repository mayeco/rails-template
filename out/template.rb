# frozen_string_literal: true

# ==============================================================================
# Rails Application Template: rails-core (GENERATED FILE - DO NOT EDIT DIRECTLY)
# Source files: template_parts/*.rb
# Built at: Sat Aug  1 00:07:48 -04 2026
# ==============================================================================

# --- Part: 01_gems.rb ---
def add_gems
  puts "\n==> 1. Configuring Gemfile with LATEST VERSION of all non-native gems..."

  inject_into_file "Gemfile", "ruby file: \".ruby-version\"\n\n", after: "source \"https://rubygems.org\"\n"

  gem 'mission_control-jobs', '>= 1.1'
  gem 'redis', '>= 5.4.1'
  gem 'hiredis-client', '>= 0.30.1'

  # Devise & OmniAuth
  gem 'devise', '>= 5.0.4'
  gem 'omniauth', '>= 2.1.4'
  gem 'omniauth-rails_csrf_protection', '>= 2.0.1'
  gem 'omniauth-google-oauth2', '>= 1.2.2'
  gem 'omniauth-facebook', '>= 11.0'
  gem 'omniauth-microsoft_graph', '>= 2.2'

  # Internationalization
  gem 'rails-i18n', '>= 8.1'
  gem 'devise-i18n', '>= 1.16'

  # Utilities & UI
  gem 'aws-sdk-s3', '>= 1.228.1', require: false
  gem 'google-cloud-storage', '>= 1.62', require: false
  gem 'tailwindcss-rails', '>= 4.6'
  gem 'simple_form', '>= 5.4.1'
  gem 'figaro', '>= 1.3'
  gem 'faraday', '>= 2.14.3'
  gem 'prefixed_ids', '>= 1.8.1'
  gem 'flash_rails_messages', '>= 2.3'
  gem 'kaminari', '>= 1.2.2'
  gem 'view_component', '>= 4.12'
  gem 'recaptcha', '>= 5.21.2'

  gem_group :development do
    gem 'amazing_print', '>= 2.0'
    gem 'bullet', '>= 8.1.3'
    gem 'letter_opener_web', '>= 3.0'
    gem 'hotwire-livereload', '>= 2.1.1'
    gem 'debugbar', '>= 0.4.3'
    gem 'better_errors', '>= 2.10.1'
    gem 'binding_of_caller', '>= 2.0'
  end

  gem_group :development, :test do
    gem 'factory_bot_rails', '>= 6.5.1'
  end
end

# --- Part: 02_configurations.rb ---
def add_configurations
  puts "\n==> 2. Configuring Environments and Base Initializers..."

  environment 'config.i18n.default_locale = (Figaro.env.app_main_locale || "es").to_sym'
  environment 'config.time_zone = Figaro.env.app_main_timezone || "America/Santiago"'
  environment "config.active_job.queue_adapter = :solid_queue", env: "development"
  environment "config.active_job.queue_adapter = :solid_queue", env: "production"

  environment "config.after_initialize do\n    Bullet.enable = true\n    Bullet.bullet_logger = true\n    Bullet.rails_logger = true\n    Bullet.console = true\n  end", env: "development"
  environment "config.action_mailer.delivery_method = :letter_opener_web", env: "development"
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }", env: "development"
  environment "config.action_mailer.default_url_options = { host: 'www.change-me.com', protocol: 'https' }", env: "production"
  environment "config.action_cable.allowed_request_origins = [%r{http://*}, %r{https://*}]", env: "development"
  environment "config.action_cable.disable_request_forgery_protection = true", env: "development"
  environment "config.mission_control.jobs.http_basic_auth_enabled = false", env: "development"

  create_file ".ruby-gemset", "#{app_name}\n", force: true

  append_to_file ".gitignore", "\n# Figaro configuration\n/config/application.yml\n" if File.exist?(".gitignore")
  append_to_file ".dockerignore", "\n# Figaro configuration\n/config/application.yml\n" if File.exist?(".dockerignore")

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
      config.button_class = "btn btn-primary my-2"
      config.boolean_label_class = ""
      config.label_text = ->(label, required, _explicit_label) { "#{label} #{required}" }
      config.boolean_style = :inline
      config.item_wrapper_tag = :div
      config.include_default_input_wrapper_class = false
      config.error_notification_class = "alert alert-error mb-4"
      config.error_method = :to_sentence
      config.input_field_error_class = "input-error"
      config.input_field_valid_class = "input-success"
      config.label_class = "label-text font-medium text-base-content/80"

      config.wrappers :vertical_form, tag: "div", class: "form-control w-full mb-4" do |b|
        b.use :html5
        b.use :placeholder
        b.optional :maxlength
        b.optional :minlength
        b.optional :pattern
        b.optional :min_max
        b.optional :readonly
        b.use :label, class: "label-text font-medium text-base-content/80 mb-1 block", error_class: "text-error"
        b.use :input,
              class: "input input-bordered w-full", error_class: "input-error", valid_class: "input-success"
        b.use :full_error, wrap_with: { tag: "p", class: "mt-1 text-xs text-error" }
        b.use :hint, wrap_with: { tag: "p", class: "mt-1 text-xs text-base-content/60" }
      end

      config.wrappers :vertical_boolean, tag: "div", class: "form-control mb-4" do |b|
        b.use :html5
        b.optional :readonly
        b.wrapper tag: "label", class: "label cursor-pointer justify-start gap-3 py-1" do |ba|
          ba.use :input, class: "checkbox checkbox-primary"
          ba.use :label, class: "label-text font-medium text-base-content/80 cursor-pointer", error_class: "text-error"
        end
        b.use :full_error, wrap_with: { tag: "p", class: "mt-1 text-xs text-error" }
        b.use :hint, wrap_with: { tag: "p", class: "mt-1 text-xs text-base-content/60" }
      end

      config.wrappers :vertical_collection, item_wrapper_class: "flex items-center gap-2",
                                            item_label_class: "my-1 text-sm font-medium text-base-content/80", tag: "div", class: "my-4" do |b|
        b.use :html5
        b.optional :readonly
        b.wrapper :legend_tag, tag: "legend", class: "text-sm font-medium text-base-content/80 mb-1",
                               error_class: "text-error" do |ba|
          ba.use :label_text
        end
        b.use :input,
              class: "checkbox checkbox-primary", error_class: "checkbox-error", valid_class: "checkbox-success"
        b.use :full_error, wrap_with: { tag: "p", class: "block mt-1 text-xs text-error" }
        b.use :hint, wrap_with: { tag: "p", class: "mt-1 text-xs text-base-content/60" }
      end

      config.wrappers :vertical_file, tag: "div", class: "form-control w-full mb-4" do |b|
        b.use :html5
        b.use :placeholder
        b.optional :maxlength
        b.optional :minlength
        b.optional :readonly
        b.use :label, class: "label-text font-medium text-base-content/80 mb-1 block", error_class: "text-error"
        b.use :input, class: "file-input file-input-bordered w-full", error_class: "file-input-error", valid_class: "file-input-success"
        b.use :full_error, wrap_with: { tag: "p", class: "mt-1 text-xs text-error" }
        b.use :hint, wrap_with: { tag: "p", class: "mt-1 text-xs text-base-content/60" }
      end

      config.wrappers :vertical_select, tag: "div", class: "form-control w-full my-4", error_class: "", valid_class: "" do |b|
        b.use :html5
        b.optional :readonly
        b.use :label, class: "label-text font-medium text-base-content/80 mb-1 block", error_class: "text-error"
        b.use :input, class: "select select-bordered w-full", error_class: "select-error", valid_class: "select-success"
        b.use :full_error, wrap_with: { tag: "p", class: "mt-1 text-xs text-error" }
        b.use :hint, wrap_with: { tag: "p", class: "mt-1 text-xs text-base-content/60" }
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
      config.skip_verify_env = %w[test cucumber development]
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
          "alert shadow-sm mb-4 flex items-center justify-between"
        end

        def alert_type_classes
          {
            success: "alert-success",
            notice:  "alert-info",
            alert:   "alert-warning",
            error:   "alert-error"
          }
        end
      end
    end
  RUBY
end

# --- Part: 03_models_and_migrations.rb ---
def add_models_and_migrations
  puts "\n==> 3. Creating Models and Migrations..."

  create_file "app/models/application_record.rb", <<~'RUBY', force: true
    class ApplicationRecord < ActiveRecord::Base
      primary_abstract_class
    end
  RUBY

  create_file "app/models/user.rb", <<~'RUBY', force: true
    class User < ApplicationRecord
      include PrefixedIds
      has_prefix_id :usr

      devise :database_authenticatable, :registerable,
             :recoverable, :rememberable, :validatable,
             :confirmable, :lockable, :trackable, :omniauthable,
             omniauth_providers: [:google_oauth2, :facebook, :microsoft_graph]

      # def self.from_omniauth(auth)
      #   raise if auth.provider.blank? || auth.uid.blank?
      #
      #   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      #     user.email = auth.info.email
      #     user.password = Devise.friendly_token[0, 20]
      #   end
      # end

      def self.from_omniauth_email(auth)
        return nil if auth.blank? || auth.info&.email.blank?

        where(email: auth.info.email).first_or_initialize do |user|
          user.password = Devise.friendly_token[0, 20]
        end
      end
    end
  RUBY

  create_file "db/migrate/20250416121353_devise_create_users.rb", <<~'RUBY', force: true
    # frozen_string_literal: true

    class DeviseCreateUsers < ActiveRecord::Migration[8.0]
      def change
        create_table :users do |t|
          ## Database authenticatable
          t.string :email,              null: false, default: ""
          t.string :encrypted_password, null: false, default: ""

          ## Recoverable
          t.string   :reset_password_token
          t.datetime :reset_password_sent_at

          ## Rememberable
          t.datetime :remember_created_at

          ## Trackable
          t.integer  :sign_in_count, default: 0, null: false
          t.datetime :current_sign_in_at
          t.datetime :last_sign_in_at
          t.string   :current_sign_in_ip
          t.string   :last_sign_in_ip

          ## Confirmable
          t.string   :confirmation_token
          t.datetime :confirmed_at
          t.datetime :confirmation_sent_at
          t.string   :unconfirmed_email

          ## Lockable
          t.integer  :failed_attempts, default: 0, null: false
          t.string   :unlock_token
          t.datetime :locked_at

          ## OmniAuth
          t.string   :provider
          t.string   :uid

          if t.respond_to?(:jsonb)
            t.jsonb :omniauth_providers, null: false, default: {}
          else
            t.json :omniauth_providers, null: false, default: {}
          end

          t.timestamps null: false
        end

        add_index :users, :email,                unique: true
        add_index :users, :reset_password_token, unique: true
        add_index :users, :confirmation_token,   unique: true
        add_index :users, :unlock_token,         unique: true
        add_index :users, [ :provider, :uid ],     unique: true
      end
    end
  RUBY
end

# --- Part: 04_controllers.rb ---
def add_controllers
  puts "\n==> 4. Generating Application and Devise Controllers..."

  create_file "app/controllers/application_controller.rb", <<~'RUBY', force: true
    class ApplicationController < ActionController::Base
      allow_browser versions: :modern
    end
  RUBY

  create_file "app/controllers/page_controller.rb", <<~'RUBY', force: true
    class PageController < ApplicationController
      before_action :authenticate_user!

      def index
        log_current_user
      end

      private

      def log_current_user
        Debugbar.msg("current_user:", { current_user: current_user }) if defined?(Debugbar)
      end
    end
  RUBY

  # Devise Controllers
  create_file "app/controllers/users/registrations_controller.rb", <<~'RUBY', force: true
    # frozen_string_literal: true

    class Users::RegistrationsController < Devise::RegistrationsController
      prepend_before_action :check_captcha, only: [:create]

      protected

      def after_inactive_sign_up_path_for(resource)
        new_user_session_path
      end

      def check_captcha
        return if verify_recaptcha(action: "REGISTRATION")

        raise Recaptcha::RecaptchaError, "Recaptcha verification failed"
      end
    end
  RUBY

  create_file "app/controllers/users/sessions_controller.rb", <<~'RUBY', force: true
    # frozen_string_literal: true

    class Users::SessionsController < Devise::SessionsController
      prepend_before_action :check_captcha, only: [:create]

      def check_captcha
        return if verify_recaptcha(action: "LOGIN")

        raise Recaptcha::RecaptchaError, "Recaptcha verification failed"
      end
    end
  RUBY

  create_file "app/controllers/users/omniauth_callbacks_controller.rb", <<~'RUBY', force: true
    # frozen_string_literal: true

    class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
      layout false

      before_action :initialize_user_from_auth_email, except: [:failure]

      def initialize_user_from_auth_email
        if auth_hash.blank? || auth_hash.info&.email.blank?
          return redirect_to new_user_session_path, alert: "Authentication failed: missing email from provider."
        end

        @user = User.from_omniauth_email(auth_hash)
        return redirect_to new_user_session_path, alert: "Authentication failed." if @user.nil?

        @user.confirm unless @user.confirmed?
        user_omniauth_providers

        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication
        else
          redirect_to new_user_registration_path, alert: @user.errors.full_messages.to_sentence
        end
      end

      def user_omniauth_providers
        provider = auth_hash["provider"]
        if @user.omniauth_providers[provider].nil?
          @user.omniauth_providers[provider] = {
            "uid": auth_hash[:uid],
            "info": auth_hash[:info]
          }
        end
        @user.save
      end

      def google_oauth2; end
      def facebook; end
      def microsoft_graph; end

      def failure
        super
      end

      private

      def auth_hash
        request.env["omniauth.auth"]
      end
    end
  RUBY
end

# --- Part: 05_helpers_services_and_jobs.rb ---
def add_helpers_services_and_jobs
  puts "\n==> 5. Adding Helpers, Services, and Jobs..."

  create_file "app/services/heroku_maintenance_service.rb", <<~'RUBY', force: true
    class HerokuMaintenanceService
      attr_reader :app_name, :api_token

      def initialize(app_name = nil, api_token = nil)
        @app_name = app_name || Figaro.env.heroku_app_name
        @api_token = api_token || Figaro.env.heroku_api_token
      end

      def enable_maintenance_mode
        update_maintenance_mode(true)
      end

      def disable_maintenance_mode
        update_maintenance_mode(false)
      end

      private

      def update_maintenance_mode(maintenance_enabled)
        response = connection.patch do |req|
          req.url "/apps/#{app_name}"
          req.body = { maintenance: maintenance_enabled }.to_json
        end

        unless response.success?
          Rails.logger.error "Failed to #{maintenance_enabled ? 'enable' : 'disable'} maintenance mode: #{response.body}"
          return false
        end

        Rails.logger.info "Maintenance mode #{maintenance_enabled ? 'enabled' : 'disabled'} for #{app_name}"

        if maintenance_enabled
          scale_dynos(dyno_type: "web")
          scale_dynos(dyno_type: "worker")
        end

        true
      rescue Faraday::Error => e
        Rails.logger.error "Heroku API error: #{e.message}"
        false
      end

      def scale_dynos(dyno_type: "web", quantity: 0)
        response = connection.patch do |req|
          req.url "/apps/#{app_name}/formation/#{dyno_type}"
          req.body = { quantity: quantity }.to_json
        end

        if response.success?
          Rails.logger.info "#{dyno_type} dynos scaled successfully for #{app_name}"
          true
        else
          Rails.logger.info "#{dyno_type} dynos failed to scaled for #{app_name}"
          false
        end
      end

      def connection
        @connection ||= Faraday.new(url: "https://api.heroku.com") do |conn|
          conn.headers["Content-Type"] = "application/json"
          conn.headers["Accept"] = "application/vnd.heroku+json; version=3"
          conn.headers["Authorization"] = "Bearer #{api_token}"
          conn.adapter Faraday.default_adapter
        end
      end
    end
  RUBY

  create_file "app/jobs/daily_execute_job.rb", <<~'RUBY', force: true
    class DailyExecuteJob < ApplicationJob
      queue_as :default

      def perform(*args)
        Rails.logger.info "Daily job completed successfully."
      end
    end
  RUBY

  create_file "app/jobs/heroku_maintenance_job.rb", <<~'RUBY', force: true
    class HerokuMaintenanceJob < ApplicationJob
      queue_as :default

      def perform(*args)
        return if Figaro.env.heroku_api_token.to_s.start_with?("dummy") || Figaro.env.heroku_api_token.blank?

        if HerokuMaintenanceService.new.enable_maintenance_mode
          Rails.logger.info "Heroku maintenance mode enabled successfully."
        else
          Rails.logger.error "Failed to enable Heroku maintenance mode."
        end
      end
    end
  RUBY
end

# --- Part: 06_locales.rb ---
def add_locales
  puts "\n==> 6. Creating Locales and Translations..."

  create_file "config/locales/es.yml", <<~'YAML', force: true
    es:
      layouts:
        application:
          log_out: "Cerrar sesión"
      page:
        index:
          welcome_back: "Bienvenido de nuevo, %{email}!"
          find_me_in: "Encuentra esta vista en %{path}"
      devise:
        sessions:
          new:
            welcome_back: "Bienvenido de nuevo"
            please_log_in: "Por favor inicia sesión en tu cuenta"
            log_in: "Iniciar sesión"
        registrations:
          new:
            create_account: "Crear una cuenta"
            sign_up_to_get_started: "Regístrate para comenzar"
            sign_up: "Registrarse"
            minimum_password_length: "%{count} caracteres mínimo"
          edit:
            edit_account: "Editar Cuenta"
            update_profile_settings: "Actualiza la configuración de tu perfil y contraseña"
            currently_waiting_confirmation_for: "Esperando confirmación para: %{email}"
            leave_blank_if_unchanged: "déjalo en blanco si no quieres cambiarlo"
            need_current_password: "necesitamos tu contraseña actual para confirmar los cambios"
            are_you_sure: "¿Estás seguro?"
            back: "Volver"
            update_profile: "Actualizar Perfil"
            cancel_account: "Cancelar mi cuenta"
            permanently_delete_account: "Eliminar permanentemente tu cuenta y todos los datos."
            delete_account: "Eliminar Cuenta"
        passwords:
          new:
            forgot_password: "¿Olvidaste tu contraseña?"
            enter_email_to_reset: "Ingresa tu correo electrónico para restablecer tu contraseña"
            send_reset_instructions: "Enviar instrucciones de restablecimiento"
          edit:
            change_password: "Cambiar contraseña"
            set_new_password: "Establece una nueva contraseña para tu cuenta"
            new_password: "Nueva contraseña"
            confirm_new_password: "Confirmar nueva contraseña"
            change_my_password: "Cambiar mi contraseña"
        confirmations:
          new:
            resend_confirmation: "Reenviar confirmación"
            request_new_confirmation_email: "Solicitar un nuevo correo de confirmación de cuenta"
            resend_instructions: "Reenviar instrucciones"
        unlocks:
          new:
            resend_unlock: "Reenviar desbloqueo"
            request_unlock_instructions: "Solicitar instrucciones para desbloquear tu cuenta"
            resend_unlock_instructions: "Reenviar instrucciones de desbloqueo"
        shared:
          links:
            already_have_account: "¿Ya tienes una cuenta?"
            log_in: "Iniciar sesión"
            dont_have_account: "¿No tienes una cuenta?"
            sign_up: "Registrarse"
            forgot_your_password: "¿Olvidaste tu contraseña?"
            didnt_receive_confirmation_instructions: "¿No recibiste las instrucciones de confirmación?"
            didnt_receive_unlock_instructions: "¿No recibiste las instrucciones de desbloqueo?"
            or_log_in_with: "o inicia sesión con"
            or_create_account_with: "o crea tu cuenta con"
        mailer:
          confirmation_instructions:
            welcome: "¡Bienvenido %{email}!"
            confirm_account_text: "Puedes confirmar el correo de tu cuenta a través del siguiente enlace:"
            confirm_account_link: "Confirmar mi cuenta"
          email_changed:
            hello: "¡Hola %{email}!"
            changing_email: "Te contactamos para notificarte que tu correo está siendo cambiado a %{email}."
            changed_email: "Te contactamos para notificarte que tu correo ha sido cambiado a %{email}."
          password_change:
            hello: "¡Hola %{email}!"
            changed_password: "Te contactamos para notificarte que tu contraseña ha sido cambiada."
          reset_password_instructions:
            hello: "¡Hola %{email}!"
            request_text: "Alguien ha solicitado un enlace para cambiar tu contraseña. Puedes hacerlo a través del enlace de abajo."
            change_password_link: "Cambiar mi contraseña"
            ignore_text: "Si no solicitaste esto, por favor ignora este correo."
            notice_text: "Tu contraseña no cambiará hasta que accedas al enlace y crees una nueva."
          unlock_instructions:
            hello: "¡Hola %{email}!"
            locked_text: "Tu cuenta ha sido bloqueada debido a un número excesivo de intentos fallidos de inicio de sesión."
            unlock_text: "Haz clic en el enlace de abajo para desbloquear tu cuenta:"
            unlock_link: "Desbloquear mi cuenta"
  YAML

  create_file "config/locales/en.yml", <<~'YAML', force: true
    en:
      layouts:
        application:
          log_out: "Log out"
      page:
        index:
          welcome_back: "Welcome back, %{email}!"
          find_me_in: "Find this view in %{path}"
      devise:
        sessions:
          new:
            welcome_back: "Welcome back"
            please_log_in: "Please log in to your account"
            log_in: "Log in"
        registrations:
          new:
            create_account: "Create an account"
            sign_up_to_get_started: "Sign up to get started"
            sign_up: "Sign up"
            minimum_password_length: "%{count} characters minimum"
          edit:
            edit_account: "Edit Account"
            update_profile_settings: "Update your profile settings and password"
            currently_waiting_confirmation_for: "Currently waiting confirmation for: %{email}"
            leave_blank_if_unchanged: "leave blank if you don't want to change it"
            need_current_password: "we need your current password to confirm your changes"
            are_you_sure: "Are you sure?"
            back: "Back"
            update_profile: "Update Profile"
            cancel_account: "Cancel my account"
            permanently_delete_account: "Permanently delete your account and all data."
            delete_account: "Delete Account"
        passwords:
          new:
            forgot_password: "Forgot password?"
            enter_email_to_reset: "Enter your email address to reset your password"
            send_reset_instructions: "Send reset instructions"
          edit:
            change_password: "Change password"
            set_new_password: "Set a new password for your account"
            new_password: "New password"
            confirm_new_password: "Confirm new password"
            change_my_password: "Change my password"
        confirmations:
          new:
            resend_confirmation: "Resend confirmation"
            request_new_confirmation_email: "Request a new account confirmation email"
            resend_instructions: "Resend instructions"
        unlocks:
          new:
            resend_unlock: "Resend unlock"
            request_unlock_instructions: "Request instructions to unlock your account"
            resend_unlock_instructions: "Resend unlock instructions"
        shared:
          links:
            already_have_account: "Already have an account?"
            log_in: "Log in"
            dont_have_account: "Don't have an account?"
            sign_up: "Sign up"
            forgot_your_password: "Forgot your password?"
            didnt_receive_confirmation_instructions: "Didn't receive confirmation instructions?"
            didnt_receive_unlock_instructions: "Didn't receive unlock instructions?"
            or_log_in_with: "or log in with"
            or_create_account_with: "or create account with"
        mailer:
          confirmation_instructions:
            welcome: "Welcome %{email}!"
            confirm_account_text: "You can confirm your account email through the link below:"
            confirm_account_link: "Confirm my account"
          email_changed:
            hello: "Hello %{email}!"
            changing_email: "We're contacting you to notify you that your email is being changed to %{email}."
            changed_email: "We're contacting you to notify you that your email has been changed to %{email}."
          password_change:
            hello: "Hello %{email}!"
            changed_password: "We're contacting you to notify you that your password has been changed."
          reset_password_instructions:
            hello: "Hello %{email}!"
            request_text: "Someone has requested a link to change your password. You can do this through the link below."
            change_password_link: "Change my password"
            ignore_text: "If you didn't request this, please ignore this email."
            notice_text: "Your password won't change until you access the link above and create a new one."
          unlock_instructions:
            hello: "Hello %{email}!"
            locked_text: "Your account has been locked due to an excessive number of unsuccessful sign in attempts."
            unlock_text: "Click the link below to unlock your account:"
            unlock_link: "Unlock my account"
  YAML
end

# --- Part: 07_views.rb ---
def add_views
  puts "\n==> 7. Creating Views and Layouts with DaisyUI Components..."

  create_file "app/views/layouts/application.html.erb", <<~'ERB', force: true
    <!DOCTYPE html>
    <html data-theme="light">
    <head>
      <title><%= content_for(:title) || Rails.application.class.module_parent_name.titleize %></title>
      <meta name="viewport" content="width=device-width,initial-scale=1">
      <meta name="apple-mobile-web-app-capable" content="yes">
      <meta name="mobile-web-app-capable" content="yes">
      <%= csrf_meta_tags %>
      <%= csp_meta_tag %>

      <%= yield :head %>

      <link rel="icon" href="/icon.png" type="image/png">
      <link rel="icon" href="/icon.svg" type="image/svg+xml">
      <link rel="apple-touch-icon" href="/icon.png">

      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
      <%= stylesheet_link_tag "application", "data-turbo-track": Rails.env.production? ? "reload" : "" %>

      <%= debugbar_head if defined? Debugbar %>
    </head>

    <body class="bg-base-200 min-h-screen flex flex-col font-sans antialiased text-base-content">
      <main class="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 my-auto py-8">
        <%= render_flash_messages if respond_to?(:render_flash_messages) %>
        <%= yield %>

        <% if user_signed_in? %>
          <div class="text-center mt-6">
            <%= button_to destroy_user_session_path, method: :delete, data: { turbo: false }, class: "btn btn-error btn-outline btn-sm gap-2" do %>
              <i class="bi bi-box-arrow-right"></i> <%= t("layouts.application.log_out") %>
            <% end %>
          </div>
        <% end %>
      </main>
      <%= debugbar_body cable: {url: "ws://localhost:3000"} if defined? Debugbar %>
    </body>
    </html>
  ERB

  create_file "app/views/page/index.html.erb", <<~'ERB', force: true
    <div class="max-w-2xl mx-auto text-center py-12">
      <h1 class="text-4xl font-extrabold tracking-tight text-base-content sm:text-5xl mb-4">
        <%= Rails.application.class.module_parent_name.titleize %>
      </h1>
      <p class="text-lg text-base-content/80 mb-8">
        <%= t(".welcome_back", email: current_user.email) %>
      </p>
      <div class="card bg-base-100 shadow-xl border border-base-200">
        <div class="card-body">
          <p class="text-sm text-base-content/70">
            <%= t(".find_me_in", path: "app/views/page/index.html.erb") %>
          </p>
        </div>
      </div>
    </div>
  ERB

  # Devise Views
  create_file "app/views/devise/sessions/new.html.erb", <<~'ERB', force: true
    <div class="max-w-md mx-auto">
      <div class="card bg-base-100 shadow-xl border border-base-200">
        <div class="card-body">
          <div class="text-center mb-6">
            <h2 class="card-title text-2xl font-bold justify-center text-base-content"><%= t(".welcome_back") %></h2>
            <p class="text-sm text-base-content/70 mt-1"><%= t(".please_log_in") %></p>
          </div>

          <%= simple_form_for(resource, as: resource_name, url: session_path(resource_name), data: { turbo: false }) do |f| %>
            <%= recaptcha_v3(action: "LOGIN") if respond_to?(:recaptcha_v3) %>

            <div class="space-y-4">
              <%= f.input :email,
                          required: false,
                          autofocus: true,
                          input_html: { autocomplete: "email" } %>

              <%= f.input :password,
                          required: false,
                          input_html: { autocomplete: "current-password" } %>

              <% if devise_mapping.rememberable? %>
                <%= f.input :remember_me, as: :boolean %>
              <% end %>
            </div>

            <div class="mt-6">
              <%= f.button :submit, t(".log_in"), class: "btn btn-primary w-full" %>
            </div>
          <% end %>

          <%= render "devise/shared/links" %>
        </div>
      </div>
    </div>
  ERB

  create_file "app/views/devise/registrations/new.html.erb", <<~'ERB', force: true
    <div class="max-w-md mx-auto">
      <div class="card bg-base-100 shadow-xl border border-base-200">
        <div class="card-body">
          <div class="text-center mb-6">
            <h2 class="card-title text-2xl font-bold justify-center text-base-content"><%= t(".create_account") %></h2>
            <p class="text-sm text-base-content/70 mt-1"><%= t(".sign_up_to_get_started") %></p>
          </div>

          <%= simple_form_for(resource, as: resource_name, url: registration_path(resource_name), data: { turbo: false }) do |f| %>
            <%= recaptcha_v3(action: "REGISTRATION") if respond_to?(:recaptcha_v3) %>

            <div class="space-y-4">
              <%= f.input :email,
                          required: true,
                          autofocus: true,
                          input_html: { autocomplete: "email" } %>

              <%= f.input :password,
                          required: true,
                          hint: (t(".minimum_password_length", count: @minimum_password_length) if @minimum_password_length),
                          input_html: { autocomplete: "new-password" } %>

              <%= f.input :password_confirmation,
                          required: true,
                          input_html: { autocomplete: "new-password" } %>
            </div>

            <div class="mt-6">
              <%= f.button :submit, t(".sign_up"), class: "btn btn-primary w-full" %>
            </div>
          <% end %>

          <%= render "devise/shared/links" %>
        </div>
      </div>
    </div>
  ERB

  create_file "app/views/devise/registrations/edit.html.erb", <<~'ERB', force: true
    <div class="max-w-lg mx-auto">
      <div class="card bg-base-100 shadow-xl border border-base-200">
        <div class="card-body">
          <div class="mb-6">
            <h2 class="card-title text-2xl font-bold text-base-content"><%= t(".edit_account") %></h2>
            <p class="text-sm text-base-content/70 mt-1"><%= t(".update_profile_settings") %></p>
          </div>

          <%= simple_form_for(resource, as: resource_name, url: registration_path(resource_name), html: { method: :put }) do |f| %>
            <%= f.error_notification %>

            <div class="space-y-4">
              <%= f.input :email, required: true, autofocus: true %>

              <% if devise_mapping.confirmable? && resource.pending_reconfirmation? %>
                <div class="alert alert-info text-xs p-3">
                  <span><%= t(".currently_waiting_confirmation_for", email: resource.unconfirmed_email) %></span>
                </div>
              <% end %>

              <%= f.input :password,
                          hint: t(".leave_blank_if_unchanged"),
                          required: false,
                          input_html: { autocomplete: "new-password" } %>

              <%= f.input :password_confirmation,
                          required: false,
                          input_html: { autocomplete: "new-password" } %>

              <%= f.input :current_password,
                          hint: t(".need_current_password"),
                          required: true,
                          input_html: { autocomplete: "current-password" } %>
            </div>

            <div class="flex items-center justify-between mt-6 gap-3">
              <%= link_to t(".back"), :back, class: "btn btn-ghost border-base-300" %>
              <%= f.button :submit, t(".update_profile"), class: "btn btn-primary" %>
            </div>
          <% end %>

          <div class="divider mt-8 mb-4"></div>

          <div class="alert alert-error bg-error/10 border-error/20 flex justify-between items-center">
            <div>
              <h3 class="text-sm font-semibold text-error"><%= t(".cancel_account") %></h3>
              <p class="text-xs text-error/80 mt-0.5"><%= t(".permanently_delete_account") %></p>
            </div>
            <%= button_to t(".delete_account"), registration_path(resource_name), data: { confirm: t(".are_you_sure"), turbo_confirm: t(".are_you_sure") }, method: :delete, class: "btn btn-error btn-sm text-white" %>
          </div>
        </div>
      </div>
    </div>
  ERB

  create_file "app/views/devise/passwords/new.html.erb", <<~'ERB', force: true
    <div class="max-w-md mx-auto">
      <div class="card bg-base-100 shadow-xl border border-base-200">
        <div class="card-body">
          <div class="text-center mb-6">
            <h2 class="card-title text-2xl font-bold justify-center text-base-content"><%= t(".forgot_password") %></h2>
            <p class="text-sm text-base-content/70 mt-1"><%= t(".enter_email_to_reset") %></p>
          </div>

          <%= simple_form_for(resource, as: resource_name, url: password_path(resource_name), html: { method: :post }) do |f| %>
            <%= f.error_notification %>

            <div class="space-y-4">
              <%= f.input :email,
                          required: true,
                          autofocus: true,
                          input_html: { autocomplete: "email" } %>
            </div>

            <div class="mt-6">
              <%= f.button :submit, t(".send_reset_instructions"), class: "btn btn-primary w-full" %>
            </div>
          <% end %>

          <%= render "devise/shared/links" %>
        </div>
      </div>
    </div>
  ERB

  create_file "app/views/devise/passwords/edit.html.erb", <<~'ERB', force: true
    <div class="max-w-md mx-auto">
      <div class="card bg-base-100 shadow-xl border border-base-200">
        <div class="card-body">
          <div class="text-center mb-6">
            <h2 class="card-title text-2xl font-bold justify-center text-base-content"><%= t(".change_password") %></h2>
            <p class="text-sm text-base-content/70 mt-1"><%= t(".set_new_password") %></p>
          </div>

          <%= simple_form_for(resource, as: resource_name, url: password_path(resource_name), html: { method: :put }) do |f| %>
            <%= f.error_notification %>

            <%= f.input :reset_password_token, as: :hidden %>
            <%= f.full_error :reset_password_token %>

            <div class="space-y-4">
              <%= f.input :password,
                          label: t(".new_password"),
                          required: true,
                          autofocus: true,
                          hint: (t("devise.registrations.new.minimum_password_length", count: @minimum_password_length) if @minimum_password_length),
                          input_html: { autocomplete: "new-password" } %>

              <%= f.input :password_confirmation,
                          label: t(".confirm_new_password"),
                          required: true,
                          input_html: { autocomplete: "new-password" } %>
            </div>

            <div class="mt-6">
              <%= f.button :submit, t(".change_my_password"), class: "btn btn-primary w-full" %>
            </div>
          <% end %>

          <%= render "devise/shared/links" %>
        </div>
      </div>
    </div>
  ERB

  create_file "app/views/devise/confirmations/new.html.erb", <<~'ERB', force: true
    <div class="max-w-md mx-auto">
      <div class="card bg-base-100 shadow-xl border border-base-200">
        <div class="card-body">
          <div class="text-center mb-6">
            <h2 class="card-title text-2xl font-bold justify-center text-base-content"><%= t(".resend_confirmation") %></h2>
            <p class="text-sm text-base-content/70 mt-1"><%= t(".request_new_confirmation_email") %></p>
          </div>

          <%= simple_form_for(resource, as: resource_name, url: confirmation_path(resource_name), html: { method: :post }) do |f| %>
            <%= f.error_notification %>
            <%= f.full_error :confirmation_token %>

            <div class="space-y-4">
              <%= f.input :email,
                          required: true,
                          autofocus: true,
                          value: (resource.pending_reconfirmation? ? resource.unconfirmed_email : resource.email),
                          input_html: { autocomplete: "email" } %>
            </div>

            <div class="mt-6">
              <%= f.button :submit, t(".resend_instructions"), class: "btn btn-primary w-full" %>
            </div>
          <% end %>

          <%= render "devise/shared/links" %>
        </div>
      </div>
    </div>
  ERB

  create_file "app/views/devise/unlocks/new.html.erb", <<~'ERB', force: true
    <div class="max-w-md mx-auto">
      <div class="card bg-base-100 shadow-xl border border-base-200">
        <div class="card-body">
          <div class="text-center mb-6">
            <h2 class="card-title text-2xl font-bold justify-center text-base-content"><%= t(".resend_unlock") %></h2>
            <p class="text-sm text-base-content/70 mt-1"><%= t(".request_unlock_instructions") %></p>
          </div>

          <%= simple_form_for(resource, as: resource_name, url: unlock_path(resource_name), html: { method: :post }) do |f| %>
            <%= f.error_notification %>
            <%= f.full_error :unlock_token %>

            <div class="space-y-4">
              <%= f.input :email,
                          required: true,
                          autofocus: true,
                          input_html: { autocomplete: "email" } %>
            </div>

            <div class="mt-6">
              <%= f.button :submit, t(".resend_unlock_instructions"), class: "btn btn-primary w-full" %>
            </div>
          <% end %>

          <%= render "devise/shared/links" %>
        </div>
      </div>
    </div>
  ERB

  create_file "app/views/devise/shared/_links.html.erb", <<~'ERB', force: true
    <div class="mt-6 pt-4 border-t border-base-200 text-center text-xs text-base-content/70 space-y-2">
      <%- if controller_name != 'sessions' %>
        <div><%= t(".already_have_account") %> <%= link_to t(".log_in"), new_session_path(resource_name), data: { turbo: false }, class: "link link-primary font-semibold" %></div>
      <% end %>

      <%- if devise_mapping.registerable? && controller_name != 'registrations' %>
        <div><%= t(".dont_have_account") %> <%= link_to t(".sign_up"), new_registration_path(resource_name), data: { turbo: false }, class: "link link-primary font-semibold" %></div>
      <% end %>

      <%- if devise_mapping.recoverable? && controller_name != 'passwords' && controller_name != 'registrations' %>
        <div><%= link_to t(".forgot_your_password"), new_password_path(resource_name), class: "link link-hover" %></div>
      <% end %>

      <%- if devise_mapping.confirmable? && controller_name != 'confirmations' %>
        <div><%= link_to t(".didnt_receive_confirmation_instructions"), new_confirmation_path(resource_name), class: "link link-hover" %></div>
      <% end %>

      <%- if devise_mapping.lockable? && resource_class.unlock_strategy_enabled?(:email) && controller_name != 'unlocks' %>
        <div><%= link_to t(".didnt_receive_unlock_instructions"), new_unlock_path(resource_name), class: "link link-hover" %></div>
      <% end %>
    </div>

    <%- if devise_mapping.omniauthable? %>
      <div class="mt-4">
        <div class="divider text-xs text-base-content/50 uppercase tracking-wider">
          <%- if controller_name == 'sessions' %>
            <%= t(".or_log_in_with") %>
          <%- else %>
            <%= t(".or_create_account_with") %>
          <% end %>
        </div>

        <div class="mt-3 flex gap-2">
          <%- resource_class.omniauth_providers.each do |provider| %>
            <%= button_to omniauth_authorize_path(resource_name, provider), data: { turbo: false }, class: "btn btn-outline btn-sm flex-1 gap-2", form_class: "flex-1" do %>
              <i class="bi bi-<%= provider.to_s.split('_').first %> text-base"></i>
              <span class="capitalize"><%= provider.to_s.split('_').first %></span>
            <% end %>
          <% end %>
        </div>
      </div>
    <% end %>
  ERB

  create_file "app/views/devise/shared/_error_messages.html.erb", <<~'ERB', force: true
    <% if resource.errors.any? %>
      <div id="error_explanation" class="alert alert-error mb-4 flex flex-col items-start" data-turbo-cache="false">
        <h3 class="text-sm font-semibold">
          <%= I18n.t("errors.messages.not_saved",
                     count: resource.errors.count,
                     resource: resource.class.model_name.human.downcase)
           %>
        </h3>
        <ul class="list-disc list-inside text-xs space-y-1">
          <% resource.errors.full_messages.each do |message| %>
            <li><%= message %></li>
          <% end %>
        </ul>
      </div>
    <% end %>
  ERB
end
# --- Part: 08_mailers.rb ---
def add_mailers
  puts "\n==> 8. Creating Mailer Views and Layouts..."

  create_file "app/views/layouts/mailer.html.erb", <<~'ERB', force: true
    <!DOCTYPE html>
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <style>
          body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; background-color: #f8fafc; color: #1e293b; margin: 0; padding: 20px; }
          .container { max-width: 580px; margin: 0 auto; background: #ffffff; border-radius: 12px; padding: 32px; border: 1px solid #e2e8f0; }
          .footer { margin-top: 24px; font-size: 12px; color: #64748b; text-align: center; }
          a { color: #4f46e5; text-decoration: none; font-weight: 500; }
        </style>
      </head>

      <body>
        <div class="container">
          <%= yield %>
        </div>
        <div class="footer">
          <p>&copy; <%= Time.current.year %> <%= Rails.application.class.module_parent_name.titleize %>. All rights reserved.</p>
        </div>
      </body>
    </html>
  ERB

  create_file "app/views/devise/mailer/confirmation_instructions.html.erb", <<~'ERB', force: true
    <p><%= t("devise.mailer.confirmation_instructions.welcome", email: @email) %></p>
    <p><%= t("devise.mailer.confirmation_instructions.confirm_account_text") %></p>
    <p><%= link_to t("devise.mailer.confirmation_instructions.confirm_account_link"), confirmation_url(@resource, confirmation_token: @token) %></p>
  ERB

  create_file "app/views/devise/mailer/email_changed.html.erb", <<~'ERB', force: true
    <p><%= t("devise.mailer.email_changed.hello", email: @email) %></p>

    <% if @resource.try(:unconfirmed_email?) %>
      <p><%= t("devise.mailer.email_changed.changing_email", email: @resource.unconfirmed_email) %></p>
    <% else %>
      <p><%= t("devise.mailer.email_changed.changed_email", email: @resource.email) %></p>
    <% end %>
  ERB

  create_file "app/views/devise/mailer/password_change.html.erb", <<~'ERB', force: true
    <p><%= t("devise.mailer.password_change.hello", email: @resource.email) %></p>
    <p><%= t("devise.mailer.password_change.changed_password") %></p>
  ERB

  create_file "app/views/devise/mailer/reset_password_instructions.html.erb", <<~'ERB', force: true
    <p><%= t("devise.mailer.reset_password_instructions.hello", email: @resource.email) %></p>
    <p><%= t("devise.mailer.reset_password_instructions.request_text") %></p>
    <p><%= link_to t("devise.mailer.reset_password_instructions.change_password_link"), edit_password_url(@resource, reset_password_token: @token) %></p>
    <p><%= t("devise.mailer.reset_password_instructions.ignore_text") %></p>
    <p><%= t("devise.mailer.reset_password_instructions.notice_text") %></p>
  ERB

  create_file "app/views/devise/mailer/unlock_instructions.html.erb", <<~'ERB', force: true
    <p><%= t("devise.mailer.unlock_instructions.hello", email: @resource.email) %></p>
    <p><%= t("devise.mailer.unlock_instructions.locked_text") %></p>
    <p><%= t("devise.mailer.unlock_instructions.unlock_text") %></p>
    <p><%= link_to t("devise.mailer.unlock_instructions.unlock_link"), unlock_url(@resource, unlock_token: @token) %></p>
  ERB
end

# --- Part: 09_routes.rb ---
def add_routes
  puts "\n==> 7. Configuring Routes (config/routes.rb)..."

  create_file "config/routes.rb", <<~'RUBY', force: true
    Rails.application.routes.draw do
      devise_for :users, controllers: {
        omniauth_callbacks: "users/omniauth_callbacks",
        registrations: "users/registrations",
        sessions: "users/sessions"
      }

      mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development? && defined?(LetterOpenerWeb)
      mount MissionControl::Jobs::Engine, at: "/jobs" if Rails.env.development? && defined?(MissionControl::Jobs)

      get "up" => "rails/health#show", as: :rails_health_check

      root "page#index"
    end
  RUBY
end

# --- Part: 10_automation_scripts.rb ---
def add_automation_scripts
  puts "\n==> 8. Preserving Automation Scripts & Procfile..."

  create_file "Procfile", <<~'PROCFILE', force: true
    web: ./bin/thrust ./bin/rails server -p ${PORT:-3000}
    worker: ./bin/jobs
    release: ./bin/rails db:prepare
  PROCFILE

  create_file "script/setup_heroku_env.sh", <<~'BASH', force: true
    #!/bin/bash
    set -euo pipefail

    # Script to set Heroku environment variables from application.yml in a single batch
    # Usage: ./setup_heroku_env.sh <heroku_app_name>

    if [ -z "${1:-}" ]; then
      echo "Usage: $0 <heroku_app_name>"
      exit 1
    fi

    APP_NAME="$1"

    if [ ! -f config/application.yml ]; then
      echo "Error: config/application.yml file not found."
      exit 1
    fi

    echo "Setting up Heroku environment variables from application.yml for ${APP_NAME}..."

    mapfile -t PAIRS < <(ruby -e '
      require "yaml"
      begin
        config = YAML.load_file("config/application.yml") || {}
        config.each do |key, value|
          next if value.nil? || value.to_s.strip.empty?
          puts "#{key}=#{value}"
        end
      rescue => e
        STDERR.puts "Error reading application.yml: #{e.message}"
        exit 1
      end
    ')

    if [ ${#PAIRS[@]} -eq 0 ]; then
      echo "No environment variables found in config/application.yml"
      exit 0
    fi

    echo "Setting ${#PAIRS[@]} environment variables on Heroku..."
    heroku config:set "${PAIRS[@]}" --app "$APP_NAME"
    heroku labs:enable runtime-dyno-metadata --app "$APP_NAME" || true

    echo "Finished setting up Heroku environment variables."
  BASH
end

# --- Part: 11_readme.rb ---
def add_readme
  puts "\n==> 11. Generating Ultra-Detailed README.md and AGENTS.md..."

  create_file "AGENTS.md", <<~'MARKDOWN', force: true
    # AGENTS.md

    This document outlines the architectural conventions, coding standards, commands, and workflows for working on this Ruby on Rails 8.1 application.

    ---

    ## 🎯 Project Overview & Core Philosophy

    This is a production-ready **Ruby on Rails 8.1** web application built with:
    - **Ruby:** 4.0+
    - **Frontend:** Tailwind CSS v4, DaisyUI v5, Importmaps, Hotwire (Turbo + Stimulus), SimpleForm, Bootstrap Icons (Note: Tailwind CSS v4 requires modern browsers, Safari 16.4+, Chrome 111+, Firefox 128+, aligned with `allow_browser versions: :modern`)
    - **Authentication:** Devise + OmniAuth (Google, Facebook, Microsoft Graph) + reCAPTCHA v3
    - **Background Jobs & Caching:** Solid Stack (`solid_queue`, `solid_cache`, `solid_cable`) + Mission Control Jobs (`/jobs`)
    - **Configuration:** Figaro (`config/application.yml` / `Figaro.env.*`)
    - **Model Identifiers:** `PrefixedIds` (`usr_...`)
    - **Testing & Security:** Minitest, FactoryBot, RuboCop Omakase, Brakeman, Bundler Audit

    ### 💡 Core Design Principles for AI Agents
    1. **Follow Conventions:** Respect Rails 8 omakase conventions, thin controllers, rich domain models, and PORO service objects for external logic.
    2. **Environment Variables via Figaro:** Never use raw `ENV["KEY"]` in application code. Always use `Figaro.env.key_name`.
    3. **i18n Mandatory:** Never hardcode user-visible text in ERB view templates. Always use `t(".key_name")` or `t("category.key")` and update both `config/locales/es.yml` and `config/locales/en.yml`.
    4. **Tailwind CSS Styling:** Use utility classes matching the slate/indigo design system (`bg-slate-50`, `bg-indigo-600`, `text-slate-800`).
    5. **Safety First:** Validate all code changes by running `bin/rails test` and `bin/rubocop`.

    ---

    ## 🛠️ Essential Commands

    ### Development Workflow

    ```bash
    bin/setup          # Initial environment setup (bundle, db:prepare, tailwind compile)
    bin/dev            # Start Rails server + Tailwind CSS compiler via Foreman
    bin/rails console  # Interactive Rails console with Pry
    ```

    ### Testing & Code Quality

    ```bash
    bin/rails test                       # Run full Minitest suite
    bin/rails test test/models/user_test.rb  # Run specific test file
    bin/rubocop                          # Ruby code style and linting
    bin/brakeman                         # Static security analysis
    bin/bundler-audit                    # Vulnerability audit for dependencies
    ```

    ---

    ## 🗺️ Codebase Map & Conventions

    | Path | Purpose & Architectural Rules |
    |------|-------------------------------|
    | `app/models/` | Active Record models. Include `PrefixedIds` and `has_prefix_id :prefix`. Keep business logic in models or services. |
    | `app/controllers/` | Request handlers inheriting from `ApplicationController`. Use strong parameters (`params.require(...).permit(...)`) and `before_action :authenticate_user!`. |
    | `app/services/` | Service objects (POROs) for multi-step domain workflows and external API calls (e.g. `HerokuMaintenanceService`). |
    | `app/jobs/` | Active Job classes processed asynchronously by **Solid Queue**. Use `queue_as :default` or custom queues. |
    | `app/views/` | ERB templates styled with Tailwind CSS. Must use `t(...)` for all strings and `simple_form_for` for forms. |
    | `app/views/layouts/mailer.html.erb` | HTML layout for transactional email templates. |
    | `config/application.yml` | Figaro configuration file containing secrets (listed in `.gitignore`). |
    | `config/application.yml.example` | Uncommitted template copy of environment variable defaults. |
    | `config/locales/` | Translation files (`es.yml` default, `en.yml`). |
    | `db/` | Database migrations and Solid Stack schemas (`queue_schema.rb`, `cache_schema.rb`, `cable_schema.rb`). |
    | `test/` | Minitest suite with FactoryBot definitions (`test/factories/`). |

    ---

    ## 📐 Code Patterns & Examples

    ### 1. Active Record Model with `PrefixedIds`

    ```ruby
    # app/models/article.rb
    # frozen_string_literal: true

    class Article < ApplicationRecord
      include PrefixedIds
      has_prefix_id :art

      belongs_to :user

      validates :title, presence: true, length: { maximum: 255 }
      validates :content, presence: true

      scope :published, -> { where.not(published_at: nil) }
    end
    ```

    ### 2. Service Object (PORO) with Faraday & Figaro

    ```ruby
    # app/services/notification_service.rb
    # frozen_string_literal: true

    class NotificationService
      attr_reader :recipient, :message

      def initialize(recipient, message)
        @recipient = recipient
        @message = message
      end

      def self.call(recipient, message)
        new(recipient, message).call
      end

      def call
        return false if recipient.blank? || message.blank?

        response = connection.post("/v1/messages", { to: recipient, body: message }.to_json)
        response.success?
  rescue Faraday::Error => e
    Rails.logger.error "NotificationService error: #{e.message}"
    false
  end

  private

  def connection
    @connection ||= Faraday.new(url: "https://api.notifications.com") do |conn|
      conn.headers["Authorization"] = "Bearer #{Figaro.env.notification_api_key}"
          conn.headers["Content-Type"] = "application/json"
        end
      end
    end
    ```

    ### 3. Controller with i18n & Prefixed ID Lookup

    ```ruby
    # app/controllers/articles_controller.rb
    # frozen_string_literal: true

    class ArticlesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_article, only: [:show, :edit, :update, :destroy]

      def index
        @articles = current_user.articles.published
      end

      def create
        @article = current_user.articles.build(article_params)
        if @article.save
          redirect_to @article, notice: t(".created_successfully")
        else
          render :new, status: :unprocessable_entity
        end
      end

      private

      def set_article
        @article = current_user.articles.find_by_prefix_id!(params[:id])
      end

      def article_params
        params.require(:article).permit(:title, :content)
      end
    end
    ```

    ### 4. Tailwind CSS View with i18n (`app/views/articles/index.html.erb`)

    ```erb
    <div class="max-w-4xl mx-auto py-8">
      <div class="flex items-center justify-between mb-6">
        <h1 class="text-2xl font-bold text-slate-900"><%= t(".title") %></h1>
        <%= link_to t(".new_article"), new_article_path, class: "px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-lg font-medium text-sm transition" %>
      </div>

      <div class="bg-white shadow-sm border border-slate-200 rounded-2xl divide-y divide-slate-100">
        <% @articles.each do |article| %>
          <div class="p-4 flex justify-between items-center">
            <h2 class="font-semibold text-slate-800"><%= article.title %></h2>
            <%= link_to t(".view"), article_path(article), class: "text-indigo-600 hover:text-indigo-800 text-sm font-medium" %>
          </div>
        <% end %>
      </div>
    </div>
    ```

    ---

    ## 🚨 Guidelines for Making Changes

    1. **Self-Verification:** Before submitting code, execute:
       ```bash
       bin/rails test && bin/rubocop
       ```
    2. **Never Expose Secrets:** Ensure new credentials are added to `config/application.yml.example` and accessed via `Figaro.env`.
    3. **Keep `es.yml` and `en.yml` Synchronized:** Whenever adding view translation keys, update both Spanish (`es.yml`) and English (`en.yml`) locale files.
  MARKDOWN

  create_file "README.md", (<<~'MARKDOWN').gsub("%APP_NAME_TITLE%", app_name.titleize).gsub("%APP_NAME_RAW%", app_name), force: true
    # 🚀 %APP_NAME_TITLE%

    > A modern, production-ready Ruby on Rails 8.1 application pre-configured with **Tailwind CSS**, **Devise & OmniAuth**, **Solid Stack**, **Figaro**, and full infrastructure tooling.

    ---

    ## 📋 Table of Contents

    - [⚡ Quick Start](#-quick-start)
    - [📦 Full Gem Ecosystem & Versions](#-complete-gem-ecosystem--versions)
    - [🔐 Authentication & OAuth](#-authentication--security)
    - [⚙️ Configurations & Environment Variables](#%EF%B8%8F-configurations--environment-variables)
    - [🗄️ Database & Solid Stack](#%EF%B8%8F-database--solid-stack)
    - [🎨 Frontend & UI System](#-frontend--ui-system)
    - [🛠️ Controllers, Routes & Views](#%EF%B8%8F-controllers-routes--views)
    - [☁️ Heroku Deployment & Scripts](#%EF%B8%8F-heroku-deployment--scripts)
    - [🧪 Testing & Security Auditing](#-testing--security-auditing)

    ---

    ## ⚡ Quick Start

    ### 1. Requirements

    - **Ruby:** `4.0+` (specified in `.ruby-version`)
    - **RVM Gemset:** `%APP_NAME_RAW%` (specified in `.ruby-gemset`)

    ### 2. Setup Application

    Clone the repository and run the setup script:

    ```bash
    bin/setup
    ```

    `bin/setup` will automatically:
    - Install all Ruby gems via Bundler.
    - Setup the database (`db/prepare`).
    - Run pending database migrations.
    - Compile initial Tailwind CSS builds.

    ### 3. Start Development Server

    Start the Rails server and live Tailwind watcher concurrently using Foreman:

    ```bash
    bin/dev
    ```

    Navigate to [http://localhost:3000](http://localhost:3000) in your browser.

    ---

    ## 📦 Complete Gem Ecosystem & Versions

    ### 🧱 Core & Framework
    - 💎 **`rails` (`~> 8.1.3`)** — Ruby on Rails 8.1 web framework.
    - ⚡ **`puma` (`>= 5.0`)** — High-performance concurrent HTTP server.
    - 📦 **`propshaft`** — Next-generation Rails asset pipeline.
    - 📄 **`jbuilder`** — JSON builder DSL.

    ### 🔐 Authentication & Security
    - 🔑 **`devise` (`>= 5.0.4`)** — Flexible, modular authentication solution.
    - 🌐 **`omniauth` (`>= 2.1.4`)** — Multi-provider authentication framework.
    - 🛡️ **`omniauth-rails_csrf_protection` (`>= 2.0.1`)** — Mitigation against CSRF on OAuth endpoints.
    - 🔍 **`omniauth-google-oauth2` (`>= 1.2.2`)** — Google OAuth2 strategy.
    - 📘 **`omniauth-facebook` (`>= 11.0`)** — Facebook OAuth strategy.
    - 🪟 **`omniauth-microsoft_graph` (`>= 2.2`)** — Microsoft Graph / Azure AD OAuth strategy.
    - 🤖 **`recaptcha` (`>= 5.21.2`)** — Google reCAPTCHA v3 protection.
    - 🌐 **`devise-i18n` (`>= 1.16`)** & **`rails-i18n` (`>= 8.1`)** — Multi-language support (default locale `:es`).

    ### 🗃️ Solid Stack & Background Jobs
    - 📥 **`solid_queue`** — Database-backed Active Job queue adapter.
    - ⚡ **`solid_cache`** — Database-backed cache store.
    - 🔌 **`solid_cable`** — Database-backed Action Cable WebSocket adapter.
    - 🎛️ **`mission_control-jobs` (`>= 1.1`)** — Dashboard GUI for monitoring jobs (mounted at `/jobs`).

    ### 🎨 Styling, Forms & UI
    - 🎨 **`tailwindcss-rails` (`>= 4.6`)** — Tailwind CSS v4 build pipeline.
    - 📝 **`simple_form` (`>= 5.4.1`)** & **`simple_form-tailwind` (`>= 0.2.0`)** — Form builder with Tailwind CSS wrappers.
    - 📦 **`view_component` (`>= 4.12`)** — Reusable, testable view component framework.
    - 📑 **`kaminari` (`>= 1.2.2`)** — Flexible, customizable pagination.
    - 💬 **`flash_rails_messages` (`>= 2.3`)** — Tailwind-styled flash message notifications.
    - 🏷️ **`prefixed_ids` (`>= 1.8.1`)** — Obfuscated, typed model IDs (e.g., `usr_12345`).
    - 📝 **`redcarpet` (`>= 3.6.1`)** — Fast Markdown processing.

    ### 🌐 Services & External Storage
    - 🔑 **`figaro` (`>= 1.3`)** — Secure application configuration via `config/application.yml`.
    - 🌐 **`faraday` (`>= 2.14.3`)** — HTTP client for API integrations.
    - ☁️ **`aws-sdk-s3` (`>= 1.228.1`)** & **`google-cloud-storage` (`>= 1.62`)** — Cloud storage providers for Active Storage.
    - 🔴 **`redis` (`>= 5.4.1`)** & **`hiredis-client` (`>= 0.30.1`)** — High-performance Redis client.

    ### 🛠️ Development & Debugging Tools
    - 🚨 **`bullet` (`>= 8.1.3`)** — Detects N+1 queries and unused eager loading.
    - ✉️ **`letter_opener_web` (`>= 3.0`)** — Web interface to inspect emails sent in development at `/letter_opener`.
    - 📊 **`debugbar` (`>= 0.4.3`)** — Real-time performance inspector bar inserted into HTML pages.
    - 🔄 **`hotwire-livereload` (`>= 2.1.1`)** — Automatically refreshes browser when view files are modified.
    - 🖨️ **`amazing_print` (`>= 2.0`)** — Pretty printer for Ruby objects in console/logger.
    - 🔍 **`pry` (`>= 0.16.0`)** — Powerful interactive console REPL.
    - 🏭 **`factory_bot_rails` (`>= 6.5.1`)** — Fixture replacement for tests (`test/factories/`).
    - 🚀 **`thruster`** — Proxy providing HTTP asset compression and caching for Puma.

    ---

    ## 🔐 Authentication & Security

    ### User Model (`app/models/user.rb`)

    The `User` model includes the following Devise modules:
    - `:database_authenticatable`
    - `:registerable`
    - `:recoverable`
    - `:rememberable`
    - `:validatable`
    - `:confirmable`
    - `:lockable`
    - `:trackable`
    - `:omniauthable` (`:google_oauth2`, `:facebook`, `:microsoft_graph`)

    ### OAuth Login Flow (`Users::OmniauthCallbacksController`)

    Users can sign in via Google, Facebook, or Microsoft. Account mapping uses `User.from_omniauth_email(auth)`:

    ```ruby
    def self.from_omniauth_email(auth)
      where(email: auth.info.email).first_or_initialize do |user|
        user.password = Devise.friendly_token[0, 20]
      end
    end
    ```

    OAuth credentials and metadata are stored per-provider in the `users.omniauth_providers` JSON column, alongside the `provider` and `uid` database columns.

    ### reCAPTCHA v3 Protection

    Registration and Login forms automatically verify reCAPTCHA tokens before processing submissions:
    - `Users::RegistrationsController#check_captcha` (`REGISTRATION` action)
    - `Users::SessionsController#check_captcha` (`LOGIN` action)

    ---

    ## ⚙️ Configurations & Environment Variables

    Environment configuration is managed through **Figaro** (`config/application.yml`).

    > ⚠️ **Note:** `config/application.yml` contains sensitive API credentials and is listed in `.gitignore`.

    ### Default Keys in `config/application.yml`

    ```yaml
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
    ```

    Access values anywhere in Ruby using `Figaro.env.<key_name>`:

    ```ruby
    site_key = Figaro.env.recaptcha_site_key
    ```

    ---

    ## 🗄️ Database & Solid Stack

    This application utilizes Rails 8's native **Solid Stack**:

    1. **Solid Queue** — Job processing (`db/queue_schema.rb`)
    2. **Solid Cache** — Database caching (`db/cache_schema.rb`)
    3. **Solid Cable** — WebSockets over database (`db/cable_schema.rb`)

    ### Mission Control Jobs Dashboard

    Access the job management interface at:
    - **Development URL:** [http://localhost:3000/jobs](http://localhost:3000/jobs)

    ### Recurring Jobs Configuration (`config/recurring.yml`)

    - `daily_execute_job`: Runs `DailyExecuteJob` every day at midnight.
    - `heroku_auto_maintenance`: Automatically triggers `HerokuMaintenanceJob` at midnight in production.
    - `clear_solid_queue_finished_jobs`: Cleans up completed queue records hourly.

    ---

    ## 🎨 Frontend & UI System

    ### Tailwind CSS v4

    Styles are configured in `app/assets/tailwind/application.css` and compiled via `rails tailwindcss:build`.

    ### Simple Form Customization

    Forms are configured in `config/initializers/simple_form_tailwind.rb` with custom slate/indigo styling and focus rings.

    ### Flash Messages Helper

    `render_flash_messages` renders clean, rounded Tailwind alert banners using `FlashRailsMessages::Base`:
    - `notice` → Blue border & background
    - `success` → Emerald border & background
    - `alert` → Amber border & background
    - `error` → Red border & background

    ---

    ## 🛠️ Controllers, Routes & Views

    ### Routes Configuration (`config/routes.rb`)

    ```ruby
    Rails.application.routes.draw do
      devise_for :users, controllers: {
        omniauth_callbacks: "users/omniauth_callbacks",
        registrations: "users/registrations",
        sessions: "users/sessions"
      }

      mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development? && defined?(LetterOpenerWeb)
      mount MissionControl::Jobs::Engine, at: "/jobs" if Rails.env.development? && defined?(MissionControl::Jobs)

      get "up" => "rails/health#show", as: :rails_health_check
      root "page#index"
    end
    ```

    ### Key Controllers

    - **`PageController#index`** — Authenticated root page (`app/views/page/index.html.erb`).
    - **`Users::RegistrationsController`** — Custom Devise sign-up with reCAPTCHA verification.
    - **`Users::SessionsController`** — Custom Devise login with reCAPTCHA verification.
    - **`Users::OmniauthCallbacksController`** — Handles OAuth authentication for Google, Facebook, and Azure.

    ---

    ## ☁️ Heroku Deployment & Scripts

    ### Procfile

    ```procfile
    web: ./bin/thrust ./bin/rails server -p ${PORT:-3000}
    worker: ./bin/jobs
    release: ./bin/rails db:prepare
    ```

    ### Heroku Configuration Synchronization Script

    To push all configuration keys from `config/application.yml` directly to your Heroku application:

    ```bash
    ./script/setup_heroku_env.sh my-heroku-app-name
    ```

    ---

    ## 🧪 Testing & Security Auditing

    Run the test suite and static security code checks:

    ```bash
    # Run Minitest suite
    bin/rails test

    # Security audits
    bin/brakeman
    bin/bundler-audit

    # Code style checking
    bin/rubocop
    ```

    ---

    *Generated with Rails Core Template.*
  MARKDOWN
end

# --- Part: 12_directory_readmes.rb ---
def add_directory_readmes
  puts "\n==> 12. Generating AI Agent & Developer Directory READMEs..."

  # 1. app/models/README.md
  create_file "app/models/README.md", <<~'MARKDOWN', force: true
    # 📦 Models (`app/models`)

    This directory contains the Active Record models representing the application's domain logic, business rules, and database interfaces.

    ## 📚 Official Documentation
    - [Active Record Basics Guide](https://guides.rubyonrails.org/active_record_basics.html)
    - [Active Model Basics Guide](https://guides.rubyonrails.org/active_model_basics.html#model)
    - [Active Record Validations Guide](https://guides.rubyonrails.org/active_record_validations.html)
    - [Active Record Associations Guide](https://guides.rubyonrails.org/association_basics.html)

    ## 🎯 Key Conventions & Architectural Rules
    - **Inheritance:** All persistent models inherit from `ApplicationRecord` (`app/models/application_record.rb`).
    - **Obfuscated IDs:** Primary models include `PrefixedIds` for typed, salt-hashed public IDs (e.g., `usr_B8511pCq5R`).
    - **Authentication:** The `User` model integrates Devise authentication, OmniAuth providers (`google_oauth2`, `facebook`, `microsoft_graph`), and reCAPTCHA support.

    ## 💡 Example Model Implementation

    ```ruby
    # app/models/article.rb
    # frozen_string_literal: true

    class Article < ApplicationRecord
      include PrefixedIds
      has_prefix_id :art

      belongs_to :user

      validates :title, presence: true, length: { maximum: 255 }
      validates :body, presence: true

      scope :published, -> { where.not(published_at: nil) }
    end
    ```
  MARKDOWN

  # 2. app/controllers/README.md
  create_file "app/controllers/README.md", <<~'MARKDOWN', force: true
    # 🕹️ Controllers (`app/controllers`)

    Controllers handle incoming HTTP requests, process business logic via models or service objects, and render HTTP responses or ERB views.

    ## 📚 Official Documentation
    - [Action Controller Overview](https://guides.rubyonrails.org/action_controller_overview.html)
    - [Devise Controllers Customization](https://github.com/heartcombo/devise#getting-started)

    ## 🎯 Key Conventions & Architectural Rules
    - **Inheritance:** All controllers inherit from `ApplicationController`.
    - **Browser Restrictions:** `ApplicationController` enforces `allow_browser versions: :modern`.
    - **Authentication Filters:** Use `before_action :authenticate_user!` to guard restricted endpoints.
    - **Devise Overrides:** Custom authentication controllers reside under `app/controllers/users/` (`RegistrationsController`, `SessionsController`, `OmniauthCallbacksController`).

    ## 💡 Example Controller Implementation

    ```ruby
    # app/controllers/articles_controller.rb
    # frozen_string_literal: true

    class ArticlesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_article, only: [:show, :edit, :update, :destroy]

      def index
        @articles = current_user.articles.published
      end

      private

      def set_article
        @article = current_user.articles.find_by_prefix_id!(params[:id])
      end

      def article_params
        params.require(:article).permit(:title, :body)
      end
    end
    ```
  MARKDOWN

  # 3. app/views/README.md
  create_file "app/views/README.md", <<~'MARKDOWN', force: true
    # 🎨 Views & Layouts (`app/views`)

    This directory contains ERB view templates, partials, and application layouts styled using **Tailwind CSS v4** and **SimpleForm**.

    ## 📚 Official Documentation
    - [Action View Overview Guide](https://guides.rubyonrails.org/action_view_overview.html)
    - [Tailwind CSS v4 Documentation](https://tailwindcss.com/docs)
    - [Rails i18n Guide](https://guides.rubyonrails.org/i18n.html)

    ## 🎯 Key Conventions & Architectural Rules
    - **No Hardcoded User Strings:** Always use Rails i18n helpers (`t(".key_name")`). Dictionaries reside in `config/locales/es.yml` and `config/locales/en.yml`.
    - **Styling:** Use Tailwind utility classes (`bg-slate-50`, `rounded-xl`, `shadow-sm`).
    - **Forms:** Use `simple_form_for` which automatically applies Tailwind form input wrappers (`config/initializers/simple_form_tailwind.rb`).
    - **Flash Alerts:** Rendered via `<%= render_flash_messages %>` (`FlashRailsMessages::Base`).

    ## 💡 Example View Template (`app/views/articles/index.html.erb`)

    ```erb
    <div class="max-w-4xl mx-auto py-8">
      <div class="flex items-center justify-between mb-6">
        <h1 class="text-2xl font-bold text-slate-900"><%= t(".title") %></h1>
        <%= link_to t(".new_article"), new_article_path, class: "px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-lg font-medium text-sm transition" %>
      </div>

      <div class="bg-white shadow-sm border border-slate-200 rounded-2xl divide-y divide-slate-100">
        <% @articles.each do |article| %>
          <div class="p-4 flex justify-between items-center">
            <div>
              <h2 class="font-semibold text-slate-800"><%= article.title %></h2>
            </div>
            <%= link_to t(".view"), article_path(article), class: "text-indigo-600 hover:text-indigo-800 text-sm font-medium" %>
          </div>
        <% end %>
      </div>
    </div>
    ```
  MARKDOWN

  # 4. app/jobs/README.md
  create_file "app/jobs/README.md", <<~'MARKDOWN', force: true
    # ⚡ Background Jobs (`app/jobs`)

    Active Job background jobs processed by Rails 8's native **Solid Queue** database backend.

    ## 📚 Official Documentation
    - [Active Job Basics Guide](https://guides.rubyonrails.org/active_job_basics.html)
    - [Solid Queue Repository](https://github.com/rails/solid_queue)

    ## 🎯 Key Conventions & Architectural Rules
    - **Adapter:** `config.active_job.queue_adapter = :solid_queue` is configured globally.
    - **Dashboard:** Mission Control Jobs interface is mounted at `/jobs` in development.
    - **Recurring Jobs:** Scheduled recurring tasks are configured in `config/recurring.yml`.
    - **Execution:** To trigger asynchronously, call `MyJob.perform_later(args)`.

    ## 💡 Example Job Implementation

    ```ruby
    # app/jobs/cleanup_audit_logs_job.rb
    # frozen_string_literal: true

    class CleanupAuditLogsJob < ApplicationJob
      queue_as :low_priority

      def perform(days_old = 30)
        AuditLog.where("created_at < ?", days_old.days.ago).delete_all
        Rails.logger.info "CleanupAuditLogsJob finished successfully."
      end
    end
    ```
  MARKDOWN

  # 5. app/services/README.md
  create_file "app/services/README.md", <<~'MARKDOWN', force: true
    # ⚙️ Service Objects (`app/services`)

    Plain Old Ruby Objects (POROs) encapsulating complex business logic, third-party API integrations, and multi-step workflows.

    ## 🎯 Key Conventions & Architectural Rules
    - **Single Responsibility Principle (SRP):** Each service class performs one primary domain task.
    - **Instantiation:** Use `.call(...)` or `.new(...).perform` class/instance conventions.
    - **Environment Configuration:** Access API keys via `Figaro.env.<key_name>`.
    - **Error Handling:** Rescue expected HTTP/Faraday exceptions and log errors cleanly via `Rails.logger`.

    ## 💡 Example Service Implementation

    ```ruby
    # app/services/payment_processor_service.rb
    # frozen_string_literal: true

    class PaymentProcessorService
      attr_reader :user, :amount

      def initialize(user, amount)
        @user = user
        @amount = amount
      end

      def self.call(user, amount)
        new(user, amount).call
      end

      def call
        return false if amount <= 0

        response = connection.post("/charges", { amount: amount, customer: user.email }.to_json)
        response.success?
  rescue Faraday::Error => e
    Rails.logger.error "Payment processing failed: \#{e.message}"
    false
  end

  private

  def connection
    @connection ||= Faraday.new(url: "https://api.paymentgateway.com") do |conn|
      conn.headers["Authorization"] = "Bearer \#{Figaro.env.payment_api_key}"
          conn.headers["Content-Type"] = "application/json"
        end
      end
    end
    ```
  MARKDOWN

  # 6. app/helpers/README.md
  create_file "app/helpers/README.md", <<~'MARKDOWN', force: true
    # 🛠️ View Helpers (`app/helpers`)

    View helpers provide reusable UI formatting logic and HTML rendering utility methods across ERB templates.

    ## 📚 Official Documentation
    - [ActionView Helpers API](https://api.rubyonrails.org/classes/ActionView/Helpers.html)

    ## 🎯 Key Conventions
    - **Global Utility Helpers:** `ApplicationHelper` contains application-wide formatting functions.
    - **Components:** For complex HTML structures or stateful UI elements, prefer `ViewComponent` (`app/components/`) over cluttered helper methods.
  MARKDOWN

  # 7. config/README.md
  create_file "config/README.md", <<~'MARKDOWN', force: true
    # 🛠️ Configuration (`config/`)

    Application configuration files, environment setups, routes, and database settings.

    ## 📚 Official Documentation
    - [Configuring Rails Applications Guide](https://guides.rubyonrails.org/configuring.html)

    ## 🎯 Key Configuration Files
    - `application.rb`: Global framework settings, time zone (`America/Santiago`), default locale (`:es`), and autoload paths.
    - `application.yml`: Environment secrets loaded by **Figaro** (`Figaro.env.*`), ignored by Git.
    - `application.yml.example`: Uncommitted template copy of environment variable defaults.
    - `environments/`: Environment-specific settings (`development.rb`, `production.rb`, `test.rb`).
    - `routes.rb`: URL routing definitions, Devise route scopes, and mounted engines.
    - `recurring.yml`: Solid Queue recurring job schedules.
    - `storage.yml`: Active Storage services (`Disk`, `S3`, `GCS`).
  MARKDOWN

  # 8. config/initializers/README.md
  create_file "config/initializers/README.md", <<~'MARKDOWN', force: true
    # 🔌 Initializers (`config/initializers`)

    Initializers execute during application boot to configure gems, singletons, and framework subsystems.

    ## 📚 Official Documentation
    - [Rails Initializers Guide](https://guides.rubyonrails.org/configuring.html#initializers)

    ## 🎯 Pre-Configured Initializers
    - `devise.rb`: Devise setup, OmniAuth providers, Turbo responder status codes, and `mailer_sender`.
    - `simple_form.rb` & `simple_form_tailwind.rb`: SimpleForm field wrappers styled for Tailwind CSS.
    - `content_security_policy.rb`: Content Security Policy allowing Google reCAPTCHA and CDN assets.
    - `recaptcha.rb`: Google reCAPTCHA v3 site & secret key setup via Figaro.
    - `redis.rb`: Redis client global configuration.
    - `prefixed_ids.rb`: Salt and minimum length for prefixed model IDs.
    - `flash_rails_messages.rb`: Tailwind CSS alert classes override for flash messages.
  MARKDOWN

  # 9. db/README.md
  create_file "db/README.md", <<~'MARKDOWN', force: true
    # 🗄️ Database Architecture & Schemas (`db/`)

    Database migrations, schema definitions, and seed data.

    ## 📚 Official Documentation
    - [Active Record Migrations Guide](https://guides.rubyonrails.org/active_record_migrations.html)

    ## 🎯 Key Schemas & Files
    - `schema.rb`: Primary database schema auto-generated by Active Record.
    - `queue_schema.rb`: Solid Queue database tables (`solid_queue_*`).
    - `cache_schema.rb`: Solid Cache database table (`solid_cache_entries`).
    - `cable_schema.rb`: Solid Cable database table (`solid_cable_messages`).
    - `migrate/`: Primary application migrations (e.g. `DeviseCreateUsers`, `CreateActiveStorageTables`).
    - `seeds.rb`: Seed file for populating initial database records (`bin/rails db:seed`).

    ## 💡 Example Migration

    ```ruby
    # db/migrate/20260727000000_create_categories.rb
    # frozen_string_literal: true

    class CreateCategories < ActiveRecord::Migration[8.1]
      def change
        create_table :categories do |t|
          t.string :name, null: false
          t.string :slug, null: false

          t.timestamps null: false
        end

        add_index :categories, :slug, unique: true
      end
    end
    ```
  MARKDOWN

  # 10. test/README.md
  create_file "test/README.md", <<~'MARKDOWN', force: true
    # 🧪 Testing Suite (`test/`)

    Minitest testing suite with **FactoryBot** fixture generation and security auditing tools.

    ## 📚 Official Documentation
    - [Testing Rails Applications Guide](https://guides.rubyonrails.org/testing.html)

    ## 🎯 Commands

    ```bash
    # Run all Minitest tests
    bin/rails test

    # Run a specific model test
    bin/rails test test/models/user_test.rb

    # Security & Code Audits
    bin/brakeman
    bin/bundler-audit
    bin/rubocop
    ```

    ## 🏭 Factories (`test/factories/`)
    - `test/factories/users.rb`: Pre-configured user factory using `FactoryBot`.
  MARKDOWN
end

# --- Part: 13_main_execution.rb ---
# ==============================================================================
# Main flow execution
# ==============================================================================

unless Rails::VERSION::STRING >= "8.1.0"
  raise "rails-core error: template requires Rails 8.1.0 or higher (detected #{Rails::VERSION::STRING})"
end

add_gems
add_configurations
add_models_and_migrations
add_controllers
add_helpers_services_and_jobs
add_locales
add_views
add_mailers
add_routes
add_automation_scripts
add_readme
add_directory_readmes

after_bundle do
  puts "\n==> Running default generators: Figaro, Tailwind CSS, Simple Form Tailwind, Devise, Action Text, Active Storage, Solid Stack..."
  run "bundle exec figaro install"

  append_to_file "config/application.yml" do
    <<~YAML
      app_main_locale: "es"
      app_main_timezone: "America/Santiago"
      recaptcha_site_key: "dummy_site_key"
      recaptcha_secret_key: "dummy_secret_key"
      redis_url: "redis://localhost:6379/0"
      prefixed_ids_salt: "#{SecureRandom.hex(32)}"
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
  end

  rails_command "tailwindcss:install"
  if File.exist?("app/views/layouts/application.html.erb")
    gsub_file "app/views/layouts/application.html.erb",
              /^\s*<%= stylesheet_link_tag "application".* %>\n?/,
              ""
  end

  puts "\n==> Installing DaisyUI v5 for Tailwind CSS v4..."
  run "curl -sLo app/assets/tailwind/daisyui.mjs https://github.com/saadeghi/daisyui/releases/latest/download/daisyui.mjs"
  run "curl -sLo app/assets/tailwind/daisyui-theme.mjs https://github.com/saadeghi/daisyui/releases/latest/download/daisyui-theme.mjs"

  if File.exist?("app/assets/tailwind/application.css")
    append_to_file "app/assets/tailwind/application.css" do
      <<~CSS

        @source not "./daisyui{,*}.mjs";

        @plugin "./daisyui.mjs";

        /* Optional for custom themes – Docs: https://daisyui.com/docs/themes/#how-to-add-a-new-custom-theme */
        @plugin "./daisyui-theme.mjs" {
          /* custom theme here */
        }
      CSS
    end
  end

  rails_command "tailwindcss:build"
  generate "devise:install"
  generate "kaminari:config"
  rails_command "action_text:install"
  rails_command "active_storage:install"
  rails_command "solid_queue:install"
  rails_command "solid_cache:install"
  rails_command "solid_cable:install"

  if File.exist?("config/puma.rb") && File.read("config/puma.rb").include?("plugin :solid_queue")
    gsub_file "config/puma.rb",
              /plugin :solid_queue.*/,
              "# You can either set the env var, or check for development\nplugin :solid_queue if ENV[\"SOLID_QUEUE_IN_PUMA\"] || Rails.env.development?"
  elsif File.exist?("config/puma.rb")
    append_to_file "config/puma.rb",
                   "\n# You can either set the env var, or check for development\nplugin :solid_queue if ENV[\"SOLID_QUEUE_IN_PUMA\"] || Rails.env.development?\n"
  end

  gsub_file "config/environments/production.rb",
            "config.active_storage.service = :local",
            "config.active_storage.service = :amazon"

  unless File.read("config/environments/production.rb").include?("config.active_storage.service = :amazon")
    raise "rails-core error: failed to configure Active Storage service in config/environments/production.rb"
  end

  puts "\n==> Customizing config/initializers/devise.rb with OmniAuth and Hotwire/Turbo..."
  inject_into_file "config/initializers/devise.rb", after: "Devise.setup do |config|\n" do
    <<~'RUBY'
        config.omniauth :google_oauth2, Figaro.env.google_client_id, Figaro.env.google_client_secret, {
          scope: "email"
        }

        config.omniauth :facebook, Figaro.env.facebook_app_id, Figaro.env.facebook_app_secret, {
          scope: "email"
        }

        config.omniauth :microsoft_graph, Figaro.env.azure_client_id, Figaro.env.azure_client_secret, {
          scope: "openid email User.Read",
          skip_domain_verification: true
        }

    RUBY
  end

  gsub_file "config/initializers/devise.rb", /config\.mailer_sender = .*/, 'config.mailer_sender = Figaro.env.mailer_sender || "no-reply@example.com"'
  gsub_file "config/initializers/devise.rb", /# config.sign_out_via = :delete/, "config.sign_out_via = :delete"

  if File.exist?("bin/setup") && File.exist?("config/application.yml.example")
    inject_into_file "bin/setup", after: "puts \"== Installing dependencies ==\"\n" do
      <<~'RUBY'
          unless File.exist?("config/application.yml")
            puts "\n== Copying config/application.yml.example to config/application.yml =="
            FileUtils.cp("config/application.yml.example", "config/application.yml")
          end
      RUBY
    end
  end

  puts "\n==> Applying custom post-installation configurations for Solid Stack..."

  create_file "config/recurring.yml", <<~'YAML', force: true
    default: &default

      daily_execute_job:
        class: DailyExecuteJob
        schedule: every day at midnight

    development:
      <<: *default

    production:
      <<: *default

      heroku_auto_maintenance:
        class: HerokuMaintenanceJob
        schedule: every day at midnight

      clear_solid_queue_finished_jobs:
        command: "SolidQueue::Job.clear_finished_in_batches(sleep_between_batches: 0.3)"
        schedule: every hour at minute 12

  YAML

  rails_command "db:prepare"
  rails_command "runner \"load 'db/queue_schema.rb' if File.exist?('db/queue_schema.rb')\""
  rails_command "runner \"load 'db/cache_schema.rb' if File.exist?('db/cache_schema.rb')\""
  rails_command "runner \"load 'db/cable_schema.rb' if File.exist?('db/cable_schema.rb')\""

  puts "\n========================================================="
  puts " RAILS-CORE TEMPLATE APPLIED SUCCESSFULLY!"
  puts "========================================================="
end

