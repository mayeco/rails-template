# frozen_string_literal: true

# ==============================================================================
# Rails Application Template: rails-core (GENERATED FILE - DO NOT EDIT DIRECTLY)
# Source files: template_parts/*.rb
# Built at: Mon Jul 27 16:18:29 -04 2026
# ==============================================================================

# --- Part: 01_gems.rb ---
def add_gems
  puts "\n==> 1. Configuring Gemfile with LATEST VERSION of all non-native gems..."

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
  gem 'amazing_print', '>= 2.0'
  gem 'aws-sdk-s3', '>= 1.228.1', require: false
  gem 'google-cloud-storage', '>= 1.62', require: false
  gem 'tailwindcss-rails', '>= 4.6'
  gem 'simple_form', '>= 5.4.1'
  gem 'simple_form-tailwind', '>= 0.2.0'
  gem 'redcarpet', '>= 3.6.1'
  gem 'figaro', '>= 1.3'
  gem 'faraday', '>= 2.14.3'
  gem 'prefixed_ids', '>= 1.8.1'
  gem 'flash_rails_messages', '>= 2.3'
  gem 'pagy', '>= 43.6.1'
  gem 'view_component', '>= 4.12'
  gem 'recaptcha', '>= 5.21.2'
  gem 'htmlcompressor', '>= 0.4.0'

  gem_group :development do
    gem 'bullet', '>= 8.1.3'
    gem 'letter_opener_web', '>= 3.0'
    gem 'pry', '>= 0.16.0'
    gem 'hotwire-livereload', '>= 2.1.1'
    gem 'debugbar', '>= 0.4.3'
  end

  gem_group :development, :test do
    gem 'factory_bot_rails', '>= 6.5.1'
  end
end

# --- Part: 02_configurations.rb ---
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
      devise :database_authenticatable, :registerable,
             :recoverable, :rememberable, :validatable,
             :confirmable, :lockable, :trackable, :omniauthable,
             omniauth_providers: [:google_oauth2, :facebook, :microsoft_graph]

      def self.from_omniauth(auth)
        raise if auth.provider.blank? || auth.uid.blank?

        where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
          user.email = auth.info.email
          user.password = Devise.friendly_token[0, 20]
        end
      end

      def self.from_omniauth_email(auth)
        raise if auth.info.email.blank?

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
        @user = User.from_omniauth_email(auth_hash)
        @user.confirm unless @user.confirmed?

        user_omniauth_providers

        if @user.persisted?
          sign_in_and_redirect @user
        else
          raise "Users::OmniauthCallbacksController: User not persisted"
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

  create_file "app/controllers/users/confirmations_controller.rb", <<~'RUBY', force: true
    # frozen_string_literal: true

    class Users::ConfirmationsController < Devise::ConfirmationsController
    end
  RUBY

  create_file "app/controllers/users/passwords_controller.rb", <<~'RUBY', force: true
    # frozen_string_literal: true

    class Users::PasswordsController < Devise::PasswordsController
    end
  RUBY

  create_file "app/controllers/users/unlocks_controller.rb", <<~'RUBY', force: true
    # frozen_string_literal: true

    class Users::UnlocksController < Devise::UnlocksController
    end
  RUBY
end

# --- Part: 05_helpers_services_and_jobs.rb ---
def add_helpers_services_and_jobs
  puts "\n==> 5. Adding Helpers, Services, and Jobs..."

  create_file "app/helpers/application_helper.rb", <<~'RUBY', force: true
    module ApplicationHelper
      def omniauth_icon(provider)
        case provider
        when :google_oauth2
          "google"
        when :facebook
          "facebook"
        when :microsoft_graph
          "microsoft"
        else
          provider
        end
      end
    end
  RUBY

  create_file "app/helpers/page_helper.rb", <<~'RUBY', force: true
    module PageHelper
    end
  RUBY

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

        if response.success?
          Rails.logger.info "Maintenance mode #{maintenance_enabled ? 'enabled' : 'disabled'} for #{app_name}"
          true
        else
          Rails.logger.error "Failed to #{maintenance_enabled ? 'enable' : 'disable'} maintenance mode: #{response.body}"
          false
        end

        if maintenance_enabled && response.success?
          scale_dynos(dyno_type: "web")
          scale_dynos(dyno_type: "worker")
        end
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

  create_file "app/jobs/application_job.rb", <<~'RUBY', force: true
    class ApplicationJob < ActiveJob::Base
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
        if HerokuMaintenanceService.new.enable_maintenance_mode
          Rails.logger.info "Heroku maintenance mode enabled successfully."
        else
          Rails.logger.error "Failed to enable Heroku maintenance mode."
        end
      end
    end
  RUBY
end

# --- Part: 06_views.rb ---
def add_views
  puts "\n==> 6. Creating Views and Layouts..."

  create_file "app/views/layouts/application.html.erb", <<~'ERB', force: true
    <!DOCTYPE html>
    <html>
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
      <%= stylesheet_link_tag :app, "data-turbo-track": "reload" %>

      <%= debugbar_head if defined? Debugbar %>
    </head>

    <body class="bg-slate-50 min-h-screen flex flex-col font-sans antialiased text-slate-800">
      <main class="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 my-auto py-8">
        <%= render_flash_messages if respond_to?(:render_flash_messages) %>
        <%= yield %>

        <% if user_signed_in? %>
          <div class="text-center mt-6">
            <%= button_to destroy_user_session_path, method: :delete, data: { turbo: false }, class: "inline-flex items-center gap-2 px-3 py-1.5 text-sm font-medium text-red-600 border border-red-200 rounded-md hover:bg-red-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 transition" do %>
              <i class="bi bi-box-arrow-right"></i> Log out
            <% end %>
          </div>
        <% end %>
      </main>
      <%= debugbar_body if defined? Debugbar %>
    </body>
    </html>
  ERB

  create_file "app/views/page/index.html.erb", <<~'ERB', force: true
    <div class="max-w-2xl mx-auto text-center py-12">
      <h1 class="text-4xl font-extrabold tracking-tight text-slate-900 sm:text-5xl mb-4">
        <%= Rails.application.class.module_parent_name.titleize %>
      </h1>
      <p class="text-lg text-slate-600 mb-8">
        Welcome back, <span class="font-semibold text-slate-800"><%= current_user.email %></span>!
      </p>
      <div class="bg-white shadow-sm border border-slate-200 rounded-xl p-6">
        <p class="text-sm text-slate-500">
          Find this view in <code class="bg-slate-100 text-slate-800 px-2 py-0.5 rounded text-xs">app/views/page/index.html.erb</code>
        </p>
      </div>
    </div>
  ERB

  # Devise Views
  create_file "app/views/devise/sessions/new.html.erb", <<~'ERB', force: true
    <div class="max-w-md mx-auto">
      <div class="bg-white shadow-md border border-slate-200 rounded-2xl p-6 sm:p-8">
        <div class="text-center mb-6">
          <h2 class="text-2xl font-bold text-slate-900">Welcome back</h2>
          <p class="text-sm text-slate-500 mt-1">Please log in to your account</p>
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
            <%= f.button :submit, "Log in", class: "w-full py-2.5 px-4 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2" %>
          </div>
        <% end %>

        <%= render "devise/shared/links" %>
      </div>
    </div>
  ERB

  create_file "app/views/devise/registrations/new.html.erb", <<~'ERB', force: true
    <div class="max-w-md mx-auto">
      <div class="bg-white shadow-md border border-slate-200 rounded-2xl p-6 sm:p-8">
        <div class="text-center mb-6">
          <h2 class="text-2xl font-bold text-slate-900">Create an account</h2>
          <p class="text-sm text-slate-500 mt-1">Sign up to get started</p>
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
                        hint: ("#{@minimum_password_length} characters minimum" if @minimum_password_length),
                        input_html: { autocomplete: "new-password" } %>

            <%= f.input :password_confirmation,
                        required: true,
                        input_html: { autocomplete: "new-password" } %>
          </div>

          <div class="mt-6">
            <%= f.button :submit, "Sign up", class: "w-full py-2.5 px-4 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2" %>
          </div>
        <% end %>

        <%= render "devise/shared/links" %>
      </div>
    </div>
  ERB

  create_file "app/views/devise/registrations/edit.html.erb", <<~'ERB', force: true
    <div class="max-w-lg mx-auto">
      <div class="bg-white shadow-md border border-slate-200 rounded-2xl p-6 sm:p-8">
        <div class="mb-6">
          <h2 class="text-2xl font-bold text-slate-900">Edit Account</h2>
          <p class="text-sm text-slate-500 mt-1">Update your profile settings and password</p>
        </div>

        <%= simple_form_for(resource, as: resource_name, url: registration_path(resource_name), html: { method: :put }) do |f| %>
          <%= f.error_notification %>

          <div class="space-y-4">
            <%= f.input :email, required: true, autofocus: true %>

            <% if devise_mapping.confirmable? && resource.pending_reconfirmation? %>
              <div class="p-3 bg-blue-50 border border-blue-200 text-blue-800 rounded-lg text-xs">
                Currently waiting confirmation for: <strong><%= resource.unconfirmed_email %></strong>
              </div>
            <% end %>

            <%= f.input :password,
                        hint: "leave blank if you don't want to change it",
                        required: false,
                        input_html: { autocomplete: "new-password" } %>

            <%= f.input :password_confirmation,
                        required: false,
                        input_html: { autocomplete: "new-password" } %>

            <%= f.input :current_password,
                        hint: "we need your current password to confirm your changes",
                        required: true,
                        input_html: { autocomplete: "current-password" } %>
          </div>

          <div class="flex items-center justify-between mt-6">
            <%= link_to "Back", :back, class: "px-4 py-2 border border-slate-300 text-slate-700 font-medium rounded-lg text-sm hover:bg-slate-50 transition" %>
            <%= f.button :submit, "Update Profile", class: "py-2.5 px-5 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2" %>
          </div>
        <% end %>

        <div class="mt-8 pt-6 border-t border-slate-200">
          <div class="bg-red-50 border border-red-200 rounded-xl p-4 flex items-center justify-between">
            <div>
              <h3 class="text-sm font-semibold text-red-900">Cancel my account</h3>
              <p class="text-xs text-red-600 mt-0.5">Permanently delete your account and data.</p>
            </div>
            <%= button_to "Delete Account", registration_path(resource_name), data: { confirm: "Are you sure?", turbo_confirm: "Are you sure?" }, method: :delete, class: "px-3 py-1.5 bg-red-600 hover:bg-red-700 text-white text-xs font-semibold rounded-md shadow-sm transition" %>
          </div>
        </div>
      </div>
    </div>
  ERB

  create_file "app/views/devise/passwords/new.html.erb", <<~'ERB', force: true
    <div class="max-w-md mx-auto">
      <div class="bg-white shadow-md border border-slate-200 rounded-2xl p-6 sm:p-8">
        <div class="text-center mb-6">
          <h2 class="text-2xl font-bold text-slate-900">Forgot password?</h2>
          <p class="text-sm text-slate-500 mt-1">Enter your email address to reset your password</p>
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
            <%= f.button :submit, "Send reset instructions", class: "w-full py-2.5 px-4 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2" %>
          </div>
        <% end %>

        <%= render "devise/shared/links" %>
      </div>
    </div>
  ERB

  create_file "app/views/devise/passwords/edit.html.erb", <<~'ERB', force: true
    <div class="max-w-md mx-auto">
      <div class="bg-white shadow-md border border-slate-200 rounded-2xl p-6 sm:p-8">
        <div class="text-center mb-6">
          <h2 class="text-2xl font-bold text-slate-900">Change password</h2>
          <p class="text-sm text-slate-500 mt-1">Set a new password for your account</p>
        </div>

        <%= simple_form_for(resource, as: resource_name, url: password_path(resource_name), html: { method: :put }) do |f| %>
          <%= f.error_notification %>

          <%= f.input :reset_password_token, as: :hidden %>
          <%= f.full_error :reset_password_token %>

          <div class="space-y-4">
            <%= f.input :password,
                        label: "New password",
                        required: true,
                        autofocus: true,
                        hint: ("#{@minimum_password_length} characters minimum" if @minimum_password_length),
                        input_html: { autocomplete: "new-password" } %>

            <%= f.input :password_confirmation,
                        label: "Confirm new password",
                        required: true,
                        input_html: { autocomplete: "new-password" } %>
          </div>

          <div class="mt-6">
            <%= f.button :submit, "Change my password", class: "w-full py-2.5 px-4 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2" %>
          </div>
        <% end %>

        <%= render "devise/shared/links" %>
      </div>
    </div>
  ERB

  create_file "app/views/devise/confirmations/new.html.erb", <<~'ERB', force: true
    <div class="max-w-md mx-auto">
      <div class="bg-white shadow-md border border-slate-200 rounded-2xl p-6 sm:p-8">
        <div class="text-center mb-6">
          <h2 class="text-2xl font-bold text-slate-900">Resend confirmation</h2>
          <p class="text-sm text-slate-500 mt-1">Request a new account confirmation email</p>
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
            <%= f.button :submit, "Resend instructions", class: "w-full py-2.5 px-4 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2" %>
          </div>
        <% end %>

        <%= render "devise/shared/links" %>
      </div>
    </div>
  ERB

  create_file "app/views/devise/unlocks/new.html.erb", <<~'ERB', force: true
    <div class="max-w-md mx-auto">
      <div class="bg-white shadow-md border border-slate-200 rounded-2xl p-6 sm:p-8">
        <div class="text-center mb-6">
          <h2 class="text-2xl font-bold text-slate-900">Resend unlock</h2>
          <p class="text-sm text-slate-500 mt-1">Request instructions to unlock your account</p>
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
            <%= f.button :submit, "Resend unlock instructions", class: "w-full py-2.5 px-4 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2" %>
          </div>
        <% end %>

        <%= render "devise/shared/links" %>
      </div>
    </div>
  ERB

  create_file "app/views/devise/shared/_links.html.erb", <<~'ERB', force: true
    <div class="mt-6 pt-4 border-t border-slate-200 text-center text-xs text-slate-500 space-y-2">
      <%- if controller_name != 'sessions' %>
        <div>Already have an account? <%= link_to "Log in", new_session_path(resource_name), data: { turbo: false }, class: "font-semibold text-indigo-600 hover:text-indigo-500" %></div>
      <% end %>

      <%- if devise_mapping.registerable? && controller_name != 'registrations' %>
        <div>Don't have an account? <%= link_to "Sign up", new_registration_path(resource_name), data: { turbo: false }, class: "font-semibold text-indigo-600 hover:text-indigo-500" %></div>
      <% end %>

      <%- if devise_mapping.recoverable? && controller_name != 'passwords' && controller_name != 'registrations' %>
        <div><%= link_to "Forgot your password?", new_password_path(resource_name), class: "hover:underline" %></div>
      <% end %>

      <%- if devise_mapping.confirmable? && controller_name != 'confirmations' %>
        <div><%= link_to "Didn't receive confirmation instructions?", new_confirmation_path(resource_name), class: "hover:underline" %></div>
      <% end %>

      <%- if devise_mapping.lockable? && resource_class.unlock_strategy_enabled?(:email) && controller_name != 'unlocks' %>
        <div><%= link_to "Didn't receive unlock instructions?", new_unlock_path(resource_name), class: "hover:underline" %></div>
      <% end %>
    </div>

    <%- if devise_mapping.omniauthable? %>
      <div class="mt-6">
        <div class="relative flex py-2 items-center">
          <div class="flex-grow border-t border-slate-200"></div>
          <span class="flex-shrink mx-3 text-xs text-slate-400 uppercase tracking-wider">
            <%- if controller_name == 'sessions' %>
              or log in with
            <%- else %>
              or create account with
            <% end %>
          </span>
          <div class="flex-grow border-t border-slate-200"></div>
        </div>

        <div class="mt-3 flex gap-2">
          <%- resource_class.omniauth_providers.each do |provider| %>
            <%= button_to omniauth_authorize_path(resource_name, provider), data: { turbo: false }, class: "flex-1 inline-flex justify-center items-center gap-2 py-2 px-3 border border-slate-300 rounded-lg shadow-sm bg-white text-xs font-medium text-slate-700 hover:bg-slate-50 transition focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2", form_class: "flex-1" do %>
              <i class="bi bi-<%= omniauth_icon(provider) %> text-base"></i>
              <span class="capitalize"><%= provider.to_s.split('_').first %></span>
            <% end %>
          <% end %>
        </div>
      </div>
    <% end %>
  ERB

  create_file "app/views/devise/shared/_error_messages.html.erb", <<~'ERB', force: true
    <% if resource.errors.any? %>
      <div id="error_explanation" class="mb-4 p-4 bg-red-50 border border-red-200 rounded-xl text-red-900" data-turbo-cache="false">
        <h3 class="text-sm font-semibold mb-2">
          <%= I18n.t("errors.messages.not_saved",
                     count: resource.errors.count,
                     resource: resource.class.model_name.human.downcase)
           %>
        </h3>
        <ul class="list-disc list-inside text-xs space-y-1 text-red-700">
          <% resource.errors.full_messages.each do |message| %>
            <li><%= message %></li>
          <% end %>
        </ul>
      </div>
    <% end %>
  ERB

  create_file "app/views/devise/mailer/confirmation_instructions.html.erb", <<~'ERB', force: true
    <p>Welcome <%= @email %>!</p>
    <p>You can confirm your account email through the link below:</p>
    <p><%= link_to 'Confirm my account', confirmation_url(@resource, confirmation_token: @token) %></p>
  ERB

  create_file "app/views/devise/mailer/email_changed.html.erb", <<~'ERB', force: true
    <p>Hello <%= @email %>!</p>

    <% if @resource.try(:unconfirmed_email?) %>
      <p>We're contacting you to notify you that your email is being changed to <%= @resource.unconfirmed_email %>.</p>
    <% else %>
      <p>We're contacting you to notify you that your email has been changed to <%= @resource.email %>.</p>
    <% end %>
  ERB

  create_file "app/views/devise/mailer/password_change.html.erb", <<~'ERB', force: true
    <p>Hello <%= @resource.email %>!</p>
    <p>We're contacting you to notify you that your password has been changed.</p>
  ERB

  create_file "app/views/devise/mailer/reset_password_instructions.html.erb", <<~'ERB', force: true
    <p>Hello <%= @resource.email %>!</p>
    <p>Someone has requested a link to change your password. You can do this through the link below.</p>
    <p><%= link_to 'Change my password', edit_password_url(@resource, reset_password_token: @token) %></p>
    <p>If you didn't request this, please ignore this email.</p>
    <p>Your password won't change until you access the link above and create a new one.</p>
  ERB

  create_file "app/views/devise/mailer/unlock_instructions.html.erb", <<~'ERB', force: true
    <p>Hello <%= @resource.email %>!</p>
    <p>Your account has been locked due to an excessive number of unsuccessful sign in attempts.</p>
    <p>Click the link below to unlock your account:</p>
    <p><%= link_to 'Unlock my account', unlock_url(@resource, unlock_token: @token) %></p>
  ERB
end

# --- Part: 07_routes.rb ---
def add_routes
  puts "\n==> 7. Configuring Routes (config/routes.rb)..."

  create_file "config/routes.rb", <<~'RUBY', force: true
    Rails.application.routes.draw do
      devise_for :users, controllers: {
        confirmations: "users/confirmations",
        omniauth_callbacks: "users/omniauth_callbacks",
        passwords: "users/passwords",
        registrations: "users/registrations",
        sessions: "users/sessions",
        unlocks: "users/unlocks"
      }

      mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
      mount MissionControl::Jobs::Engine, at: "/jobs"

      get "up" => "rails/health#show", as: :rails_health_check

      root "page#index"
    end
  RUBY
end

# --- Part: 08_automation_scripts.rb ---
def add_automation_scripts
  puts "\n==> 8. Preserving Automation Scripts in script/..."

  create_file "script/setup_heroku_env.sh", <<~'BASH', force: true
    #!/bin/bash
    heroku labs:enable runtime-dyno-metadata
    if [ -z "$1" ]; then
      APP_ARGUMENT=""
    else
      APP_ARGUMENT="--app $1"
    fi

    if [ ! -f config/application.yml ]; then
      echo "Error: config/application.yml file not found."
      exit 1
    fi

    while IFS=':' read -r key value || [[ -n "$key" ]]; do
      if [[ -z "$key" || "$key" == \#* ]]; then continue; fi
      key=$(echo "$key" | xargs)
      value=$(echo "$value" | xargs)
      if [[ -z "$key" || -z "$value" ]]; then continue; fi
      echo "Setting $key..."
      heroku config:set "$key=$value" $APP_ARGUMENT
    done < config/application.yml
  BASH
end

# --- Part: 09_main_execution.rb ---
# ==============================================================================
# Main flow execution
# ==============================================================================

add_gems
add_configurations
add_models_and_migrations
add_controllers
add_helpers_services_and_jobs
add_views
add_routes
add_automation_scripts

after_bundle do
  puts "\n==> Running default generators: Tailwind CSS, Simple Form Tailwind, Devise, Active Storage, Solid Stack..."
  rails_command "tailwindcss:install"
  generate "simple_form:tailwind:install"
  generate "devise:install"
  rails_command "active_storage:install"
  rails_command "solid_queue:install"
  rails_command "solid_cache:install"
  rails_command "solid_cable:install"

  puts "\n==> Customizing config/initializers/devise.rb with OmniAuth and Hotwire/Turbo..."
  inject_into_file "config/initializers/devise.rb", after: "Devise.setup do |config|\n" do
    <<~RUBY
      config.responder.error_status = :unprocessable_entity
      config.responder.redirect_status = :see_other

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

  gsub_file "config/initializers/devise.rb", /# config.sign_out_via = :delete/, "config.sign_out_via = :delete"

  puts "\n==> Applying custom post-installation configurations for Solid Stack and Importmaps..."

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

  append_to_file "config/importmap.rb" do
    <<~RUBY
      pin "trix"
      pin "@rails/actiontext", to: "actiontext.esm.js"
    RUBY
  end

  rails_command "db:migrate"
  rails_command "runner \"if File.exist?('db/queue_schema.rb'); load 'db/queue_schema.rb'; load 'db/cache_schema.rb'; load 'db/cable_schema.rb'; end\""

  puts "\n========================================================="
  puts " RAILS-CORE TEMPLATE APPLIED SUCCESSFULLY!"
  puts "========================================================="
end

