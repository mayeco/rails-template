# AGENT.md

This document serves as the primary technical specification and operational manual for AI agents and developers working on the `rails-core` template repository.

---

## 🎯 Repository Overview

This repository is **NOT** a Rails application. It is a **modular application template generator** for **Ruby on Rails 8.1+**.

- **Project Name:** `rails-core`
- **Purpose:** Bootstraps production-ready Rails 8.1 web applications configured with industry best practices, modern dependencies, authentication, background jobs, and operational infrastructure.
- **Generator Pattern:** The template is authored as 13 modular Ruby scripts (`template_parts/*.rb`) and compiled into a single executable Rails application template script (`out/template.rb`).
- **Core Technology Targets:**
  - Ruby 4.0+
  - Rails 8.1+
  - Tailwind CSS v4 + DaisyUI v5
  - Devise + OmniAuth (Google, Facebook, Microsoft Graph) + Identities
  - Solid Stack (`solid_queue`, `solid_cache`, `solid_cable`) + Mission Control Jobs
  - Figaro (`config/application.yml` / `Figaro.env.*`)
  - PrefixedIds (`usr_...`)
  - Bilingual i18n (Default Spanish `:es`, English `:en`)

---

## 🚨 Cardinal Rules for AI Agents

1. **NEVER Edit `out/template.rb` Directly:**
   `out/template.rb` is an auto-generated build artifact. Any manual edits will be overwritten. Always edit the appropriate modular files inside `template_parts/`.

2. **Always Rebuild After Modifying Template Parts:**
   Whenever you modify any file in `template_parts/`, you must immediately compile the template:
   ```bash
   ./build_template.sh
   ```
   This script concatenates all parts in order and validates Ruby syntax with `ruby -c`.

3. **Verify Changes with `generate_test.sh`:**
   Always test template modifications by spinning up a fresh test application:
   ```bash
   ./generate_test.sh --skip-git --cleanup
   ```
   Or without `--cleanup` to inspect generated files in `tmp/test_app_<timestamp>/`.

4. **Preserve Thor File Generation Syntax:**
   Code in `template_parts/*.rb` runs within the context of a Rails Template generator (`Thor` / `Rails::Generators`). Use proper generator methods (`create_file`, `inject_into_file`, `gsub_file`, `append_to_file`, `gem`, `initializer`, `environment`).

5. **Beware of String Interpolation in Heredocs:**
   - Use non-interpolated heredocs (`<<~'RUBY'` or `<<~'MARKDOWN'`) when generated code contains Ruby interpolation (`#{...}`) or shell variables that should remain intact in the generated file.
   - Use interpolated heredocs (`<<~RUBY`) only when the template compiler needs to inject values at template execution time (e.g. `#{SecureRandom.hex(32)}`).

---

## 🗺️ Repository Structure

```text
.
├── build_template.sh              # Compiles template_parts/*.rb into out/template.rb
├── generate_test.sh               # Generates a temporary Rails app in tmp/ to test template
├── template_parts/                # Source modular template components (Single Source of Truth)
│   ├── 01_gems.rb                 # Gemfile dependencies and groups
│   ├── 02_configurations.rb       # Initializers, Figaro, storage, CSP, redis, devise config
│   ├── 03_models_and_migrations.rb# Models (User, Identity) and database migrations
│   ├── 04_controllers.rb          # ApplicationController, PageController, Devise controllers
│   ├── 05_helpers_services_and_jobs.rb # Application helpers, Heroku maintenance service, recurring jobs
│   ├── 06_locales.rb              # Translation dictionaries (es.yml, en.yml)
│   ├── 07_views.rb                # View layout, root landing page, Devise Tailwind ERB views
│   ├── 08_mailers.rb              # Mailer layout, Devise notification templates
│   ├── 09_routes.rb               # Application routes (config/routes.rb)
│   ├── 10_automation_scripts.rb   # Production Procfile and Heroku env sync scripts
│   ├── 11_readme.rb               # Generated app README.md and root AGENTS.md
│   ├── 12_directory_readmes.rb    # Directory-level AI agent guides inside generated app
│   └── 13_main_execution.rb      # Version validation, module orchestration, and after_bundle hooks
├── out/
│   └── template.rb                # Compiled Rails template artifact (DO NOT EDIT)
├── tmp/                           # Ignored directory for scratch files and test apps
└── .opencode/
    └── skills/
        └── update-rails-template/ # OpenCode skill reference for template workflows
```

---

## 📦 Template Parts Reference

The template compilation proceeds strictly in numerical order from `01` to `13`. Each part encapsulates a specific responsibility:

| Part | File | Primary Responsibility |
|---|---|---|
| `01` | `01_gems.rb` | Defines required gems (`devise`, `omniauth-*`, `tailwindcss-rails`, `simple_form`, `solid_queue`, `solid_cache`, `solid_cable`, `kaminari`, `faraday`, `figaro`, `view_component`, etc.) across main, `:development`, and `:test` groups. |
| `02` | `02_configurations.rb` | Generates initializers (`simple_form_tailwind.rb`, `figaro.rb`, `redis.rb`, `content_security_policy.rb`, `prefixed_ids.rb`, `factory_bot.rb`), sets Active Storage configs, and configures Action Cable. |
| `03` | `03_models_and_migrations.rb` | Generates `User` and `Identity` models with multi-provider OAuth, `has_prefix_id :usr`, database migrations, and password reset / confirmation structures. |
| `04` | `04_controllers.rb` | Creates `ApplicationController` (with `allow_browser :modern`), `PageController` (root action), and overridden Devise controllers (`SessionsController`, `RegistrationsController`, `OmniauthCallbacksController`). |
| `05` | `05_helpers_services_and_jobs.rb` | Implements `ApplicationHelper` (flash messages, title helpers), `HerokuMaintenanceService` (dyno management via Heroku API), and Active Jobs (`DailyExecuteJob`, `HerokuMaintenanceJob`). |
| `06` | `06_locales.rb` | Bilingual i18n dictionaries for Spanish (`config/locales/es.yml`) and English (`config/locales/en.yml`), covering navigation, Devise auth messages, and errors. |
| `07` | `07_views.rb` | Complete UI view suite: `application.html.erb` layout, landing page (`page/index.html.erb`), and styled Devise authentication views using Tailwind CSS and SimpleForm. |
| `08` | `08_mailers.rb` | Mailer HTML/Text layouts and customized transactional email templates for Devise (password reset, email confirmation, account unlock). |
| `09` | `09_routes.rb` | Route definitions (`config/routes.rb`) mounting Devise, root to `page#index`, Mission Control Jobs at `/jobs`, and Letter Opener Web at `/letter_opener` in development. |
| `10` | `10_automation_scripts.rb` | Deployment and ops files: `Procfile` (web, worker, release), and `script/setup_heroku_env.sh` to sync Figaro variables to Heroku. |
| `11` | `11_readme.rb` | Injects an exhaustive `README.md` and root `AGENTS.md` into the *generated application* for end-developer documentation. |
| `12` | `12_directory_readmes.rb` | Places specialized `README.md` files inside `app/models/`, `app/controllers/`, `app/views/`, `app/services/`, `app/jobs/`, `config/`, and `test/` within the generated application. |
| `13` | `13_main_execution.rb` | Enforces Rails `>= 8.1.0`, invokes `add_*` methods, and runs `after_bundle` hooks (installs Figaro, Tailwind, DaisyUI v5 assets, Devise, Solid Stack migrations, and runs `db:migrate`). |

---

## ⚡ Lifecycle: How the Template Executes

Understanding the execution lifecycle inside Rails template engine:

1. **Pre-bundle Phase (`template_parts/01` to `12`):**
   - Gems are appended to `Gemfile`.
   - File templates, views, initializers, models, and migrations are created in the target application directory.
   - Configuration blocks are injected into `config/environments/` and `config/application.rb`.

2. **Bundler Execution:**
   - Rails runs `bundle install` using the updated `Gemfile`.

3. **Post-bundle Phase (`after_bundle` in `template_parts/13_main_execution.rb`):**
   - Runs generator tasks that require gems to be installed:
     - `bundle exec figaro install`
     - Populates `config/application.yml` with baseline default keys.
     - Installs and builds Tailwind CSS v4 (`rails tailwindcss:install`).
     - Downloads and configures DaisyUI v5 vendor assets (`daisyui.mjs`, `daisyui-theme.mjs`).
     - Generates Devise initializers and Kaminari config.
     - Installs Action Text and Active Storage.
     - Installs Solid Stack (`solid_queue:install`, `solid_cache:install`, `solid_cable:install`).
     - Configures `config/puma.rb` to run Solid Queue in development.
     - Injects OmniAuth providers and reCAPTCHA into Devise config.
     - Executes database schema migrations (`rails db:migrate` and Solid Stack schemas).

---

## 🛠️ Developer & Agent Workflows

### 1. Modifying Existing Functionality
1. Locate the responsible file in `template_parts/*.rb`.
2. Apply changes preserving generator conventions.
3. Rebuild the template:
   ```bash
   ./build_template.sh
   ```
4. Verify with syntax checking and generation test:
   ```bash
   ./generate_test.sh --skip-git --cleanup
   ```

### 2. Adding a New Dependency or Gem
1. In `template_parts/01_gems.rb`, declare the gem under the appropriate group:
   ```ruby
   gem "my_gem", "~> 1.2"
   ```
2. If the gem requires initializers, add them in `template_parts/02_configurations.rb`.
3. If the gem requires generators or migrations during setup, add the execution step inside the `after_bundle` block in `template_parts/13_main_execution.rb`.
4. Rebuild: `./build_template.sh`.

### 3. Adding Configuration Keys
- Any environment variable used by generated apps must be retrieved via `Figaro.env.<key_name>`.
- Add dummy default keys to `config/application.yml` inside `template_parts/13_main_execution.rb`.
- Add matching documentation to the generated app's `AGENTS.md` and `README.md` inside `template_parts/11_readme.rb`.

### 4. Running Verification Checks
`generate_test.sh` automates full-stack generation verification:
```bash
# Fast verification with automatic cleanup
./generate_test.sh --skip-git --cleanup

# Retain generated app in tmp/ for manual debugging
./generate_test.sh --skip-git
```
When debugging a generated app in `tmp/test_app_<timestamp>`:
```bash
cd tmp/test_app_<timestamp>
bin/rails runner "puts User.count; puts SolidQueue::Job.count"
bin/rails test
```

---

## 📋 Generated Application Architectural Standards

Code emitted by this template must adhere to the following standards:

1. **Rails 8 Omakase:** Thin controllers, rich domain models, minimal external abstractions unless justified.
2. **Single-Tenant Operational Focus:** Favors clean, single-tenant architectures focused on core teams (e.g. avoid premature multi-tenancy and over-normalized tables; prefer PostgreSQL JSONB with standard GIN indexing when appropriate).
3. **Strict Secrets Management:** Never use raw `ENV["KEY"]`. Always use `Figaro.env.key_name`.
4. **Mandatory i18n:** Zero hardcoded user-facing strings in views or controllers. Everything passes through `t(...)` with parity in `es.yml` and `en.yml`.
5. **Modern Frontend:** Tailwind CSS v4 utility classes paired with DaisyUI v5 components. No unnecessary custom CSS files.
6. **Obfuscated Public IDs:** Models exposed to users must use `PrefixedIds` (`has_prefix_id :prefix`).
7. **Queues & Caching:** All background processing is queued through Solid Queue (`queue_as :default`). Caching uses Solid Cache.
