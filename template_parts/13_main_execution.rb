# ==============================================================================
# Main flow execution
# ==============================================================================

unless Gem::Version.new(Rails::VERSION::STRING) >= Gem::Version.new("8.1.0")
  raise "rails-core error: template requires Rails 8.1.0 or higher (detected #{Rails::VERSION::STRING})"
end

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
    <<~YAML
      appname: "#{app_name}"
      hostname: "127.0.0.1"
      username: "postgres"
      password: "password"
      app_main_locale: "es"
      app_main_timezone: "America/Santiago"
      recaptcha_site_key: "dummy_site_key"
      recaptcha_secret_key: "dummy_secret_key"
      redis_url: "redis://localhost:6379/0"
      prefixed_ids_salt: "#{SecureRandom.hex(32)}"
      google_client_id: "dummy_google_id"
      google_client_secret: "dummy_google_secret"
      facebook_app_id: "dummy_facebook_id"
      facebook_app_secret: "dummy_facebook_secret"
      azure_client_id: "dummy_azure_id"
      azure_client_secret: "dummy_azure_secret"
      heroku_app_name: "dummy_heroku_app_name"
      heroku_api_token: "dummy_heroku_api_token"
      mailer_sender: "no-reply@example.com"
      mailer_host: "www.change-me.com"
      aws_access_key_id: "dummy_aws_access_key_id"
      aws_secret_access_key: "dummy_aws_secret_access_key"
      aws_region: "us-east-1"
      aws_bucket: "dummy_bucket"
      gcs_project: "dummy_gcs_project"
      gcs_credentials: "config/gcs.json"
      gcs_bucket: "dummy_gcs_bucket"
    YAML
  end

  configure_database

  rails_command "tailwindcss:install"
  if File.exist?("app/views/layouts/application.html.erb")
    gsub_file "app/views/layouts/application.html.erb",
              /^\s*<%= stylesheet_link_tag "application".* %>\n?/,
              ""
  end

  puts "\n==> Installing DaisyUI v5 for Tailwind CSS v4..."
  DAISYUI_VERSION = "5.7.16"
  run "curl -fsSLo app/assets/tailwind/daisyui.mjs https://github.com/saadeghi/daisyui/releases/download/v#{DAISYUI_VERSION}/daisyui.mjs"
  run "curl -fsSLo app/assets/tailwind/daisyui-theme.mjs https://github.com/saadeghi/daisyui/releases/download/v#{DAISYUI_VERSION}/daisyui-theme.mjs"

  unless File.size?("app/assets/tailwind/daisyui.mjs")
    raise "rails-core error: failed to download DaisyUI assets"
  end

  if File.exist?("app/assets/tailwind/application.css")
    append_to_file "app/assets/tailwind/application.css" do
      <<~CSS

        @source not "./daisyui{,*}.mjs";

        @plugin "./daisyui.mjs";

        /* Optional for custom themes – Docs: https://daisyui.com/docs/themes/#how-to-add-a-new-custom-theme */
        @plugin "./daisyui-theme.mjs" {
          /* custom theme here */
        }
      CSS
    end
  end

  rails_command "tailwindcss:build"
  generate "simple_form:install", "--template-engine=erb"
  generate "devise:install"
  generate "kaminari:config"
  rails_command "action_text:install"
  rails_command "active_storage:install"
  rails_command "solid_queue:install"
  rails_command "solid_cache:install"
  rails_command "solid_cable:install"

  if File.exist?("config/puma.rb") && File.read("config/puma.rb").include?("plugin :solid_queue")
    gsub_file "config/puma.rb",
              /plugin :solid_queue.*/,
              "# You can either set the env var, or check for development\nplugin :solid_queue if ENV[\"SOLID_QUEUE_IN_PUMA\"] || Rails.env.development?"
  elsif File.exist?("config/puma.rb")
    append_to_file "config/puma.rb",
                   "\n# You can either set the env var, or check for development\nplugin :solid_queue if ENV[\"SOLID_QUEUE_IN_PUMA\"] || Rails.env.development?\n"
  end

  gsub_file "config/environments/production.rb",
            "config.active_storage.service = :local",
            "config.active_storage.service = :amazon"

  unless File.read("config/environments/production.rb").include?("config.active_storage.service = :amazon")
    raise "rails-core error: failed to configure Active Storage service in config/environments/production.rb"
  end

  puts "\n==> Customizing config/initializers/devise.rb with OmniAuth and Hotwire/Turbo..."
  inject_into_file "config/initializers/devise.rb", after: "Devise.setup do |config|\n" do
    <<~'RUBY'
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

  if File.exist?("Dockerfile")
    gsub_file "Dockerfile", "COPY Gemfile Gemfile.lock ./", "COPY Gemfile Gemfile.lock .ruby-version ./"
  end

  if File.exist?("bin/setup") && File.exist?("config/application.yml.example")
    inject_into_file "bin/setup", after: "puts \"== Installing dependencies ==\"\n" do
      <<~'RUBY'
          unless File.exist?("config/application.yml")
            puts "\n== Copying config/application.yml.example to config/application.yml =="
            FileUtils.cp("config/application.yml.example", "config/application.yml")
            require "securerandom"
            yml = "config/application.yml"
            content = File.read(yml)
            if content.include?('prefixed_ids_salt: "default_salt_key_123"')
              File.write(yml, content.sub('prefixed_ids_salt: "default_salt_key_123"',
                                          "prefixed_ids_salt: \"#{SecureRandom.hex(32)}\""))
              puts "== Generated random prefixed_ids_salt =="
            end
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

  rails_command "db:prepare"
  rails_command "runner \"load 'db/queue_schema.rb' if File.exist?('db/queue_schema.rb')\""
  rails_command "runner \"load 'db/cache_schema.rb' if File.exist?('db/cache_schema.rb')\""
  rails_command "runner \"load 'db/cable_schema.rb' if File.exist?('db/cable_schema.rb')\""

  configure_gitignore

  puts "\n========================================================="
  puts " RAILS-CORE TEMPLATE APPLIED SUCCESSFULLY!"
  puts "========================================================="
end

MACOS_GITIGNORE_FALLBACK = <<~'GITIGNORE'
  # General
  .DS_Store
  .localized
  __MACOSX/
  .AppleDouble
  .LSOverride
  Icon[]

  # Resource forks
  ._*

  # Files and directories that might appear in the root of a volume
  .DocumentRevisions-V100
  .fseventsd
  .Spotlight-V100
  .TemporaryItems
  .Trashes
  .VolumeIcon.icns
  .com.apple.timemachine.donotpresent
  .com.apple.timemachine.supported
  .PKInstallSandboxManager
  .PKInstallSandboxManager-SystemSoftware
  .hotfiles.btree
  .vol
  .file
  .disk_label*
  lost+found
  .HFS+ Private Directory Data[]

  # Directories potentially created on remote AFP share
  .AppleDB
  .AppleDesktop
  Network Trash Folder
  Temporary Items
  .apdisk

  # Mac OS 6 to 9
  Desktop DB
  Desktop DF
  TheFindByContentFolder
  TheVolumeSettingsFolder
  .FBCIndex
  .FBCSemaphoreFile
  .FBCLockFolder

  # Quota system
  .quota.group
  .quota.user
  .quota.ops.group
  .quota.ops.user

  # TimeMachine
  Backups.backupdb
  .MobileBackups
  .MobileBackups.trash
  MobileBackups.trash
  tmbootpicker.efi
GITIGNORE

JETBRAINS_GITIGNORE_FALLBACK = <<~'GITIGNORE'
  # Covers JetBrains IDEs: IntelliJ, GoLand, RubyMine, PhpStorm, AppCode, PyCharm, CLion, Android Studio, WebStorm and Rider
  # Reference: https://intellij-support.jetbrains.com/hc/en-us/articles/206544839

  # User-specific stuff
  .idea/**/workspace.xml
  .idea/**/tasks.xml
  .idea/**/usage.statistics.xml
  .idea/**/dictionaries
  .idea/**/shelf

  # AWS User-specific
  .idea/**/aws.xml

  # Generated files
  .idea/**/contentModel.xml

  # Sensitive or high-churn files
  .idea/**/dataSources/
  .idea/**/dataSources.ids
  .idea/**/dataSources.local.xml
  .idea/**/sqlDataSources.xml
  .idea/**/dynamic.xml
  .idea/**/uiDesigner.xml
  .idea/**/dbnavigator.xml

  # Gradle
  .idea/**/gradle.xml
  .idea/**/libraries

  # Gradle and Maven with auto-import
  # .idea/artifacts
  # .idea/compiler.xml
  # .idea/jarRepositories.xml
  # .idea/modules.xml
  # .idea/*.iml
  # .idea/modules
  # *.iml
  # *.ipr

  # CMake
  cmake-build-*/

  # Mongo Explorer plugin
  .idea/**/mongoSettings.xml

  # File-based project format
  *.iws

  # IntelliJ
  out/

  # mpeltonen/sbt-idea plugin
  .idea_modules/

  # JIRA plugin
  atlassian-ide-plugin.xml

  # Cursive Clojure plugin
  .idea/replstate.xml

  # SonarLint plugin
  .idea/sonarlint/
  .idea/sonarlint.xml

  # Crashlytics plugin (for Android Studio and IntelliJ)
  com_crashlytics_export_strings.xml
  crashlytics.properties
  crashlytics-build.properties
  fabric.properties

  # Editor-based HTTP Client
  .idea/httpRequests
  http-client.private.env.json

  # Android studio 3.1+ serialized cache file
  .idea/caches/build_file_checksums.ser

  # Apifox Helper cache
  .idea/.cache/.Apifox_Helper
  .idea/ApifoxUploaderProjectSetting.xml

  # Github Copilot persisted session migrations
  .idea/**/copilot.data.migration.*.xml
GITIGNORE

def configure_gitignore
  return unless File.exist?(".gitignore")
  return if File.read(".gitignore").include?("Global macOS ignore rules")

  puts "\n==> Appending macOS and JetBrains rules to .gitignore..."
  macos_url = "https://raw.githubusercontent.com/github/gitignore/refs/heads/main/Global/macOS.gitignore"
  jetbrains_url = "https://raw.githubusercontent.com/github/gitignore/refs/heads/main/Global/JetBrains.gitignore"

  macos_content = begin
    require "open-uri"
    URI.open(macos_url, open_timeout: 5, read_timeout: 5).read
  rescue StandardError
    `curl -fsSL #{macos_url}` rescue nil
  end

  jetbrains_content = begin
    require "open-uri"
    URI.open(jetbrains_url, open_timeout: 5, read_timeout: 5).read
  rescue StandardError
    `curl -fsSL #{jetbrains_url}` rescue nil
  end

  macos_content = MACOS_GITIGNORE_FALLBACK if macos_content.to_s.strip.empty?
  jetbrains_content = JETBRAINS_GITIGNORE_FALLBACK if jetbrains_content.to_s.strip.empty?

  append_to_file ".gitignore" do
    <<~GITIGNORE

      # ==============================================================================
      # Global macOS ignore rules
      # Source: #{macos_url}
      # ==============================================================================
      #{macos_content.strip}

      # ==============================================================================
      # JetBrains IDEs (RubyMine, IntelliJ, etc.)
      # ==============================================================================
      # Covers user-specific settings, caches, and temporary project data.

      .idea/
      *.iml
      *.ipr
      *.iws

      # If you choose to share project settings via Git, un-comment the lines below
      # but keep user-specific configurations ignored:
      # !.idea/codeStyles/
      # !.idea/runConfigurations/
      # .idea/workspace.xml
      # .idea/tasks.xml
      # .idea/shelf/

      # ==============================================================================
      # Global JetBrains ignore rules
      # Source: #{jetbrains_url}
      # ==============================================================================
      #{jetbrains_content.strip}
    GITIGNORE
  end
end
