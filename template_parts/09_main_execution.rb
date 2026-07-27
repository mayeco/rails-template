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
  puts "\n==> Running default generators: Devise, Simple Form, Active Storage, Solid Stack, and Pundit..."
  generate "devise:install"
  generate "simple_form:install"
  rails_command "active_storage:install"
  rails_command "solid_queue:install"
  rails_command "solid_cache:install"
  rails_command "solid_cable:install"

  puts "\n==> Customizing config/initializers/devise.rb with OmniAuth and Hotwire/Turbo..."
  inject_into_file "config/initializers/devise.rb", after: "Devise.setup do |config|\n" do
    <<~RUBY
      config.responder.error_status = :unprocessable_entity
      config.responder.redirect_status = :see_other

      config.omniauth :google_oauth2, ENV["GOOGLE_CLIENT_ID"].presence || (defined?(Figaro) && Figaro.env.google_client_id rescue nil) || "dummy_google_id", ENV["GOOGLE_CLIENT_SECRET"].presence || (defined?(Figaro) && Figaro.env.google_client_secret rescue nil) || "dummy_google_secret", {
        scope: "email"
      }

      config.omniauth :facebook, ENV["FACEBOOK_APP_ID"].presence || (defined?(Figaro) && Figaro.env.facebook_app_id rescue nil) || "dummy_facebook_id", ENV["FACEBOOK_APP_SECRET"].presence || (defined?(Figaro) && Figaro.env.facebook_app_secret rescue nil) || "dummy_facebook_secret", {
        scope: "email"
      }

      config.omniauth :microsoft_graph, ENV["AZURE_CLIENT_ID"].presence || (defined?(Figaro) && Figaro.env.azure_client_id rescue nil) || "dummy_azure_id", ENV["AZURE_CLIENT_SECRET"].presence || (defined?(Figaro) && Figaro.env.azure_client_secret rescue nil) || "dummy_azure_secret", {
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
  YAML

  create_file "config/queue.yml", <<~'YAML', force: true
    default: &default
      dispatchers:
        - polling_interval: 1
          batch_size: 500
      workers:
        - queues: "*"
          threads: 3
          processes: <%= ENV.fetch("JOB_CONCURRENCY", 1) %>
          polling_interval: 0.1

    development:
      <<: *default

    test:
      <<: *default

    production:
      <<: *default
  YAML

  create_file "config/cache.yml", <<~'YAML', force: true
    default: &default
      store_options:
        max_size: <%= 256.megabytes %>
        namespace: <%= Rails.env %>

    development:
      database: cache
      <<: *default

    test:
      <<: *default

    production:
      database: cache
      <<: *default
  YAML

  create_file "config/importmap.rb", <<~'RUBY', force: true
    pin "application"
    pin "@hotwired/turbo-rails", to: "turbo.min.js"
    pin "@hotwired/stimulus", to: "stimulus.min.js"
    pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
    pin_all_from "app/javascript/controllers", under: "controllers"
    pin "trix"
    pin "@rails/actiontext", to: "actiontext.esm.js"
  RUBY

  rails_command "db:migrate"
  rails_command "runner \"load 'db/queue_schema.rb'; load 'db/cache_schema.rb'; load 'db/cable_schema.rb'\" if File.exist?('db/queue_schema.rb')"

  puts "\n========================================================="
  puts " RAILS-CORE TEMPLATE APPLIED SUCCESSFULLY!"
  puts "========================================================="
end
