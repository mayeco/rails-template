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

    Users can sign in via Google, Facebook, or Microsoft. Account mapping uses `User.from_omniauth(auth, current_user)`:

    ```ruby
    def self.from_omniauth(auth, current_user = nil)
      identity = Identity.find_by(provider: auth.provider, uid: auth.uid)
      # 1. Known identity -> return its user
      # 2. Logged-in user -> link the new provider to their account
      # 3. Otherwise -> find or create the user by email and attach the identity
    end
    ```

    OAuth credentials are stored per-provider in the `identities` table (`provider`, `uid`, `email`), linked to `users` via `user_id`. This allows one user to link multiple providers. Password is optional for 100% social accounts (`User#password_required?` returns false when identities exist).

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
