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
