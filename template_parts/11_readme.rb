def add_readme
  puts "\n==> 8b. Generating Ultra-Detailed README.md..."

  create_file "README.md", <<~MARKDOWN, force: true
    # 🚀 #{app_name.titleize}

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
    - **RVM Gemset:** `#{app_name}` (specified in `.ruby-gemset`)
    - **SQLite3:** `2.1+`

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
    - 🗄️ **`sqlite3` (`>= 2.1`)** — Lightweight embedded SQL engine.
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
    - 📑 **`pagy` (`>= 43.6.1`)** — Ultra-fast, lightweight pagination.
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
