# Rails Core Template (`rails-core`)

A modular, production-ready Rails application template generator designed to quickly bootstrap new Ruby on Rails 8.1 applications with industry best practices, modern dependencies, and built-in infrastructure tooling.

## Features

- **Modular Architecture**: Structured into 12 discrete, ordered template parts (`template_parts/*.rb`) and compiled into a single executable script via `build_template.sh`.
- **Authentication & OAuth**: Pre-configured **Devise** with multi-provider **OmniAuth** (Google OAuth2, Facebook, Microsoft Graph), **reCAPTCHA v3** protection, and **PrefixedIds** (`usr_...`).
- **Solid Stack & Queues**: **Solid Queue** (set as default `queue_adapter`), **Solid Cache**, and **Solid Cable** integration, complete with **Mission Control Jobs** dashboard mounted at `/jobs`.
- **UI & Frontend**: **Tailwind CSS v4** (`tailwindcss-rails`), **SimpleForm** with custom Tailwind wrappers, **ViewComponent**, **Kaminari** pagination, **Bootstrap Icons**, and Tailwind-styled **Flash Messages**.
- **Internationalization (i18n)**: Default Spanish locale (`:es`) with complete bilingual dictionary files (`es.yml` and `en.yml`) and `devise-i18n`.
- **Configuration & Security**: Automated **Figaro** configuration (`config/application.yml` git-ignored by default with example file `config/application.yml.example`), and working baseline **Content Security Policy (CSP)**.
- **Rich Content & Uploads**: Pre-installed **ActionText** and **Active Storage** configured for S3 (`aws-sdk-s3`) and Google Cloud Storage (`google-cloud-storage`).
- **Monitoring & Debugging**: **Debugbar**, **Bullet** N+1 detector (console/log), and **Letter Opener Web** for development email previews at `/letter_opener`.
- **Automation & Heroku Tooling**:
  - `Procfile`: Ready for Heroku/Thrust web dynos, worker dynos, and release phases.
  - `script/setup_heroku_env.sh`: Automatically syncs local environment variables from `config/application.yml` to Heroku.

---

## File Structure

```text
.
├── build_template.sh              # Script to compile template_parts/*.rb into out/template.rb
├── generate_test.sh               # Test script to generate a Rails app in tmp/ and run verification checks
├── template_parts/
│   ├── 01_gems.rb                 # Gemfile dependencies and groups
│   ├── 02_configurations.rb       # Initializers, Figaro, Storage, CSP, and FactoryBot
│   ├── 03_models_and_migrations.rb# User model with Devise, PrefixedIds & migrations
│   ├── 04_controllers.rb          # ApplicationController, PageController, and Devise controllers
│   ├── 05_helpers_services_and_jobs.rb # Application helpers, Heroku maintenance service & jobs
│   ├── 06_locales.rb              # Translation files (config/locales/es.yml and en.yml)
│   ├── 07_views.rb                # Layouts and Devise web view templates
│   ├── 08_mailers.rb              # Mailer layouts and Devise email templates
│   ├── 09_routes.rb               # Application routes (config/routes.rb)
│   ├── 10_automation_scripts.rb   # Procfile and Heroku environment sync scripts
│   ├── 11_readme.rb               # Ultra-detailed generated application README.md
│   ├── 12_directory_readmes.rb    # Specific README.md guides for AI agents in critical directories
│   └── 13_main_execution.rb      # Main execution flow and after_bundle generators
└── out/
    └── template.rb                # Compiled Rails application template (generated output)
```

---

## Getting Started

### 1. Generating a New Rails Application

To create a new Rails application using this template:

```bash
rails new my_app -m /path/to/out/template.rb
```

Alternatively, apply the template to an existing application:

```bash
bin/rails app:template LOCATION=/path/to/out/template.rb
```

### 2. Modifying and Rebuilding the Template

Do **not** edit `out/template.rb` directly, as it is generated from source files in `template_parts/`.

1. Edit the relevant file(s) inside `template_parts/`.
2. Rebuild the main template script:

```bash
./build_template.sh
```

This updates `out/template.rb`.

### 3. Testing the Template

Generate a test Rails application using the compiled template and verify that all database tables, models, and environments boot properly:

```bash
./generate_test.sh --skip-git
```

You can pass any additional flags directly to `generate_test.sh` (e.g., `./generate_test.sh --skip-git --skip-kamal`), which will forward them to `rails new`.

---

## Automation Scripts

The generated Rails app includes helpful automation scripts in `script/`:

- **Heroku Config Sync**:
  ```bash
  ./script/setup_heroku_env.sh my-heroku-app
  ```
  Parses `config/application.yml` and pushes configuration key-value pairs directly to your Heroku app.

---

## License

This project is open-source and available under the [MIT License](LICENSE).
