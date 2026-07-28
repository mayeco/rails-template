# ==============================================================================
# Main flow execution
# ==============================================================================

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
    <<~'YAML'
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
  end

  rails_command "tailwindcss:install"
  generate "devise:install"
  generate "kaminari:config"
  rails_command "action_text:install"
  rails_command "active_storage:install"
  rails_command "solid_queue:install"
  rails_command "solid_cache:install"
  rails_command "solid_cable:install"

  gsub_file "config/environments/production.rb",
            "config.active_storage.service = :local",
            "config.active_storage.service = :amazon"

  puts "\n==> Customizing config/initializers/devise.rb with OmniAuth and Hotwire/Turbo..."
  inject_into_file "config/initializers/devise.rb", after: "Devise.setup do |config|\n" do
    <<~'RUBY'
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

  gsub_file "config/initializers/devise.rb", /config\.mailer_sender = .*/, 'config.mailer_sender = Figaro.env.mailer_sender || "no-reply@example.com"'
  gsub_file "config/initializers/devise.rb", /# config.sign_out_via = :delete/, "config.sign_out_via = :delete"

  if File.exist?("bin/setup") && File.exist?("config/application.yml.example")
    inject_into_file "bin/setup", after: "puts \"== Installing dependencies ==\"\n" do
      <<~'RUBY'
        unless File.exist?("config/application.yml")
          puts "\\n== Copying config/application.yml.example to config/application.yml =="
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

  rails_command "db:migrate"
  rails_command "runner \"load 'db/queue_schema.rb' if File.exist?('db/queue_schema.rb')\""
  rails_command "runner \"load 'db/cache_schema.rb' if File.exist?('db/cache_schema.rb')\""
  rails_command "runner \"load 'db/cable_schema.rb' if File.exist?('db/cable_schema.rb')\""

  puts "\n========================================================="
  puts " RAILS-CORE TEMPLATE APPLIED SUCCESSFULLY!"
  puts "========================================================="
end
