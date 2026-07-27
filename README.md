# Rails Core Template (`rails-core`)

A modular, production-ready Rails application template generator designed to quickly bootstrap new Ruby on Rails applications with industry best practices, modern dependencies, and built-in infrastructure tooling.

## Features

- **Modular Design**: Structured into organized template parts (`template_parts/*.rb`) and built into a single executable template script via `build_template.sh`.
- **Authentication & OAuth**: Pre-configured **Devise** with multi-provider **OmniAuth** support (Google OAuth2, Facebook, Microsoft Graph) and **reCAPTCHA v3** protection.
- **Solid Stack & Queues**: **Solid Queue**, **Solid Cache**, and **Solid Cable** integration, complete with **Mission Control Jobs** dashboard at `/jobs`.
- **Performance & Caching**: **Redis** / **Hiredis** initializer, **HtmlCompressor** middleware for response minification, and N+1 query detection via **Bullet**.
- **Monitoring & Debugging**: **Sentry** error reporting integration, **Debugbar**, and **Letter Opener Web** for development email previews at `/letter_opener`.
- **UI & Helpers**: Integrated **SimpleForm**, **ViewComponent**, **Pagy** pagination, **Webpixels CSS** (Elegant theme), **Bootstrap 5**, and flash message components.
- **Security & Identifiers**: **PrefixedIds** for human-readable and obfuscated model identifiers.
- **Automation & Heroku Tooling**:
  - `script/setup_heroku_env.sh`: Shell script to automatically push local environment variables from `config/application.yml` to Heroku.

---

## File Structure

```text
.
├── build_template.sh              # Script to assemble template_parts/*.rb into template.rb
├── template.rb                    # Compiled Rails application template (generated file)
├── template_parts/
│   ├── 01_gems.rb                 # Core, UI, utility, and development gems
│   ├── 02_configurations.rb       # Environment settings and initializers
│   ├── 03_models_and_migrations.rb# Base User model & Devise migration
│   ├── 04_controllers.rb          # PageController and custom Devise controllers
│   ├── 05_helpers_services_and_jobs.rb # Application helpers, Heroku maintenance service & jobs
│   ├── 06_views.rb                # Layouts, Devise views, and OmniAuth buttons
│   ├── 07_routes.rb               # Mounted engines, health checks, and root route
│   ├── 08_automation_scripts.rb   # Infrastructure and Heroku setup scripts
│   └── 09_main_execution.rb      # Template execution flow and post-bundle setup
└── out/
    └── template.rb                # Build output directory
```

---

## Getting Started

### 1. Generating a New Rails Application

To create a new Rails application using this template:

```bash
rails new my_app -m /path/to/template.rb
```

Alternatively, apply the template to an existing application:

```bash
bin/rails app:template LOCATION=/path/to/template.rb
```

### 2. Modifying and Rebuilding the Template

Do **not** edit `template.rb` directly, as it is generated from the source files inside `template_parts/`.

1. Edit the relevant file(s) in `template_parts/`.
2. Rebuild the main template by running:

```bash
./build_template.sh
```

This updates both `out/template.rb` and `template.rb` at the root of the project.

---

## Automation Scripts

The generated Rails app includes helpful automation scripts located in `script/`:

- **Heroku Config Sync**:
  ```bash
  ./script/setup_heroku_env.sh my-heroku-app
  ```
  Parses `config/application.yml` and pushes configuration key-value pairs directly to your Heroku app.

---

## License

This project is open-source and available under the [MIT License](LICENSE).
