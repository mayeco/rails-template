---
name: update-rails-template
description: "Guidelines and workflows for updating, compiling, and testing the modular Rails application template generator (rails-core)."
---

# Rails Core Template Development & Update Skill

This skill provides step-by-step instructions and best practices for developing, updating, compiling, and testing the `rails-core` modular Rails application template.

---

## 🛠️ Key Architectural Rules

1. **NEVER Edit Output Files Directly:**
   - Do **NOT** edit `out/template.rb` or any root `template.rb` file manually.
   - All source code resides inside **`template_parts/*.rb`**.

2. **Sequential Template Parts Structure:**
   - `01_gems.rb`: Gemfile dependency declarations (`gem 'name', '>= version'`).
   - `02_configurations.rb`: Environment initializers, storage settings, FactoryBot setup, CSP, and `.ruby-gemset`.
   - `03_models_and_migrations.rb`: `User` model (`Devise`, `PrefixedIds`, `OmniAuth`) and initial migrations.
   - `04_controllers.rb`: `ApplicationController`, `PageController`, and custom Devise controllers (`SessionsController`, `RegistrationsController`, `OmniauthCallbacksController`).
   - `05_helpers_services_and_jobs.rb`: Services (`HerokuMaintenanceService`), Jobs (`DailyExecuteJob`, `HerokuMaintenanceJob`), and Application Helpers.
   - `06_locales.rb`: Locale translation dictionaries (`config/locales/es.yml` and `config/locales/en.yml`).
   - `07_views.rb`: Application layout (`application.html.erb`), root view (`page/index.html.erb`), and Devise Tailwind ERB templates.
   - `08_mailers.rb`: Email layout (`mailer.html.erb`) and Devise mailer templates.
   - `09_routes.rb`: Application routes definition (`config/routes.rb`).
   - `10_automation_scripts.rb`: Production `Procfile` and Heroku sync scripts.
   - `11_readme.rb`: Generated application's `README.md`.
   - `12_main_execution.rb`: Main template execution sequence and `after_bundle` hooks.

---

## 🔄 Standard Workflow to Apply Changes

Whenever modifying the template:

### Step 1: Edit the Corresponding `template_parts/*.rb` File
Modify or add features in the specific modular file. Preserve clean indentations and Thor file generation syntax (`create_file`, `append_to_file`, `inject_into_file`, `gsub_file`).

### Step 2: Compile the Main Template
Run the compilation shell script:

```bash
./build_template.sh
```

This concatenates all `template_parts/*.rb` files into `out/template.rb`.

### Step 3: Test and Verify Application Generation
Execute the test generator script to spawn a fresh Rails 8.1 application in `./tmp/test_app_<timestamp>/`:

```bash
./generate_test.sh --skip-git
```

### Step 4: Verify Runtime Functionality
Test active models, database schemas, and configurations inside the test application:

```bash
cd tmp/test_app_<timestamp>
bin/rails runner "User.count; SolidQueue::Job.count"
bin/rails test
```

---

## 📐 Coding & Design Conventions

- **Tailwind CSS v4:** Always use Tailwind utility classes in views and initializers.
- **Form Wrappers:** Forms use `simple_form` with custom Tailwind wrappers (`config/initializers/simple_form_tailwind.rb`).
- **i18n Translations:** Hardcoded strings in views are forbidden. Always use `t(...)` helpers and keep both `es.yml` and `en.yml` updated in `template_parts/06_locales.rb`.
- **Environment Variables (Figaro):** Reference configuration via `Figaro.env.<key_name>`. Append dummy defaults in `template_parts/12_main_execution.rb` after `run "bundle exec figaro install"`.
- **Solid Stack Schemas:** Always load schema files individually with existence checks:
  ```ruby
  rails_command "runner \"load 'db/queue_schema.rb' if File.exist?('db/queue_schema.rb')\""
  ```
