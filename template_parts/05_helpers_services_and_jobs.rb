def add_helpers_services_and_jobs
  puts "\n==> 5. Adding Helpers, Services, and Jobs..."

  create_file "app/helpers/application_helper.rb", <<~'RUBY', force: true
    module ApplicationHelper
      def omniauth_icon(provider)
        case provider
        when :google_oauth2
          "google"
        when :facebook
          "facebook"
        when :microsoft_graph
          "microsoft"
        else
          provider
        end
      end
    end
  RUBY

  create_file "app/helpers/page_helper.rb", <<~'RUBY', force: true
    module PageHelper
    end
  RUBY

  create_file "app/services/heroku_maintenance_service.rb", <<~'RUBY', force: true
    class HerokuMaintenanceService
      attr_reader :app_name, :api_token

      def initialize(app_name = nil, api_token = nil)
        @app_name = app_name || Figaro.env.heroku_app_name
        @api_token = api_token || Figaro.env.heroku_api_token
      end

      def enable_maintenance_mode
        update_maintenance_mode(true)
      end

      def disable_maintenance_mode
        update_maintenance_mode(false)
      end

      private

      def update_maintenance_mode(maintenance_enabled)
        response = connection.patch do |req|
          req.url "/apps/#{app_name}"
          req.body = { maintenance: maintenance_enabled }.to_json
        end

        if response.success?
          Rails.logger.info "Maintenance mode #{maintenance_enabled ? 'enabled' : 'disabled'} for #{app_name}"
          true
        else
          Rails.logger.error "Failed to #{maintenance_enabled ? 'enable' : 'disable'} maintenance mode: #{response.body}"
          false
        end

        if maintenance_enabled && response.success?
          scale_dynos(dyno_type: "web")
          scale_dynos(dyno_type: "worker")
        end
      rescue Faraday::Error => e
        Rails.logger.error "Heroku API error: #{e.message}"
        false
      end

      def scale_dynos(dyno_type: "web", quantity: 0)
        response = connection.patch do |req|
          req.url "/apps/#{app_name}/formation/#{dyno_type}"
          req.body = { quantity: quantity }.to_json
        end

        if response.success?
          Rails.logger.info "#{dyno_type} dynos scaled successfully for #{app_name}"
          true
        else
          Rails.logger.info "#{dyno_type} dynos failed to scaled for #{app_name}"
          false
        end
      end

      def connection
        @connection ||= Faraday.new(url: "https://api.heroku.com") do |conn|
          conn.headers["Content-Type"] = "application/json"
          conn.headers["Accept"] = "application/vnd.heroku+json; version=3"
          conn.headers["Authorization"] = "Bearer #{api_token}"
          conn.adapter Faraday.default_adapter
        end
      end
    end
  RUBY

  create_file "app/jobs/application_job.rb", <<~'RUBY', force: true
    class ApplicationJob < ActiveJob::Base
    end
  RUBY

  create_file "app/jobs/daily_execute_job.rb", <<~'RUBY', force: true
    class DailyExecuteJob < ApplicationJob
      queue_as :default

      def perform(*args)
        Rails.logger.info "Daily job completed successfully."
      end
    end
  RUBY

  create_file "app/jobs/heroku_maintenance_job.rb", <<~'RUBY', force: true
    class HerokuMaintenanceJob < ApplicationJob
      queue_as :default

      def perform(*args)
        if HerokuMaintenanceService.new.enable_maintenance_mode
          Rails.logger.info "Heroku maintenance mode enabled successfully."
        else
          Rails.logger.error "Failed to enable Heroku maintenance mode."
        end
      end
    end
  RUBY
end
