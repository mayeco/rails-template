def add_automation_scripts
  puts "\n==> 8. Preserving Automation Scripts in script/..."

  create_file "script/setup_heroku_env.sh", <<~'BASH', force: true
    #!/bin/bash
    heroku labs:enable runtime-dyno-metadata
    if [ -z "$1" ]; then
      APP_ARGUMENT=""
    else
      APP_ARGUMENT="--app $1"
    fi

    if [ ! -f config/application.yml ]; then
      echo "Error: config/application.yml file not found."
      exit 1
    fi

    while IFS=':' read -r key value || [[ -n "$key" ]]; do
      if [[ -z "$key" || "$key" == \#* ]]; then continue; fi
      key=$(echo "$key" | xargs)
      value=$(echo "$value" | xargs)
      if [[ -z "$key" || -z "$value" ]]; then continue; fi
      echo "Setting $key..."
      heroku config:set "$key=$value" $APP_ARGUMENT
    done < config/application.yml
  BASH
end
