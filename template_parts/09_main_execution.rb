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
  generate "simple_form:install --bootstrap"
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
