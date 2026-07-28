def add_automation_scripts
  puts "\n==> 8. Preserving Automation Scripts & Procfile..."

  create_file "Procfile", <<~'PROCFILE', force: true
    web: ./bin/thrust ./bin/rails server -p ${PORT:-3000}
    worker: ./bin/jobs
    release: ./bin/rails db:prepare
  PROCFILE

  create_file "script/setup_heroku_env.sh", <<~'BASH', force: true
    #!/bin/bash

    # Script to set Heroku environment variables from application.yml
    # Usage: ./setup_heroku_env.sh [heroku_app_name]

    heroku labs:enable runtime-dyno-metadata

    if [ -z "$1" ]; then
      APP_ARGUMENT=""
    else
      APP_ARGUMENT="--app $1"
    fi

    # Make sure application.yml exists
    if [ ! -f config/application.yml ]; then
      echo "Error: config/application.yml file not found."
      exit 1
    fi

    echo "Setting up Heroku environment variables from application.yml..."

    # Read application.yml and convert to Heroku config:set commands
    while IFS=':' read -r key value || [[ -n "$key" ]]; do
      # Skip empty lines and comments
      if [[ -z "$key" || "$key" == \#* ]]; then
        continue
      fi
      
      # Trim whitespace from key and value
      key=$(echo "$key" | xargs)
      value=$(echo "$value" | xargs)
      
      # Skip if key or value is empty
      if [[ -z "$key" || -z "$value" ]]; then
        continue
      fi
      
      echo "Setting $key..."
      heroku config:set "$key=$value" $APP_ARGUMENT
    done < config/application.yml

    echo "Finished setting up Heroku environment variables."
  BASH
end
