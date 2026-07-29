def add_automation_scripts
  puts "\n==> 8. Preserving Automation Scripts & Procfile..."

  create_file "Procfile", <<~'PROCFILE', force: true
    web: ./bin/thrust ./bin/rails server -p ${PORT:-3000}
    worker: ./bin/jobs
    release: ./bin/rails db:prepare
  PROCFILE

  create_file "script/setup_heroku_env.sh", <<~'BASH', force: true
    #!/bin/bash
    set -euo pipefail

    # Script to set Heroku environment variables from application.yml in a single batch
    # Usage: ./setup_heroku_env.sh <heroku_app_name>

    if [ -z "${1:-}" ]; then
      echo "Usage: $0 <heroku_app_name>"
      exit 1
    fi

    APP_NAME="$1"

    if [ ! -f config/application.yml ]; then
      echo "Error: config/application.yml file not found."
      exit 1
    fi

    echo "Setting up Heroku environment variables from application.yml for ${APP_NAME}..."

    mapfile -t PAIRS < <(ruby -e '
      require "yaml"
      begin
        config = YAML.load_file("config/application.yml") || {}
        config.each do |key, value|
          next if value.nil? || value.to_s.strip.empty?
          puts "#{key}=#{value}"
        end
      rescue => e
        STDERR.puts "Error reading application.yml: #{e.message}"
        exit 1
      end
    ')

    if [ ${#PAIRS[@]} -eq 0 ]; then
      echo "No environment variables found in config/application.yml"
      exit 0
    fi

    echo "Setting ${#PAIRS[@]} environment variables on Heroku..."
    heroku config:set "${PAIRS[@]}" --app "$APP_NAME"
    heroku labs:enable runtime-dyno-metadata --app "$APP_NAME" || true

    echo "Finished setting up Heroku environment variables."
  BASH
end
