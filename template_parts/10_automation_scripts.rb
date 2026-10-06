def add_automation_scripts
  puts "\n==> 10. Preserving Automation Tasks & Procfile..."

  create_file "Procfile", <<~'PROCFILE', force: true
    web: ./bin/thrust ./bin/rails server -p ${PORT:-3000}
    worker: ./bin/jobs
    release: ./bin/rails db:prepare
  PROCFILE

  create_file "lib/tasks/setup_heroku_env.rake", <<~'RAKE', force: true
    # frozen_string_literal: true

    namespace :heroku do
      desc "Set Heroku environment variables from config/application.yml in a single batch"
      task :setup_env, [:app_name] => :environment do |_t, args|
        app_name = args[:app_name].presence ||
                   ENV["APP_NAME"].presence ||
                   ENV["HEROKU_APP"].presence ||
                   (defined?(Figaro) && Figaro.env.heroku_app_name.presence.then { |n| n == "dummy_heroku_app_name" ? nil : n })

        if app_name.blank?
          abort <<~USAGE
            Usage:
              bin/rails "heroku:setup_env[<heroku_app_name>]"
              # or:
              bin/rails "setup_heroku_env[<heroku_app_name>]"
              # or:
              APP_NAME=<heroku_app_name> bin/rails heroku:setup_env
          USAGE
        end

        yml_path = Rails.root.join("config", "application.yml")
        unless File.exist?(yml_path)
          abort "Error: #{yml_path} file not found."
        end

        begin
          raw_config = YAML.load_file(yml_path) || {}
        rescue StandardError => e
          abort "Error reading application.yml: #{e.message}"
        end

        pairs = raw_config.each_with_object([]) do |(key, value), acc|
          next if value.nil? || value.to_s.strip.empty?

          acc << "#{key}=#{value}"
        end

        if pairs.empty?
          puts "No environment variables found in config/application.yml"
        else
          puts "Setting up Heroku environment variables from application.yml for #{app_name}..."
          puts "Setting #{pairs.size} environment variables on Heroku..."

          begin
            success = system("heroku", "config:set", *pairs, "--app", app_name)
            unless success
              abort "Error: Failed to set Heroku environment variables (status: #{$?.exitstatus})."
            end
          rescue Errno::ENOENT
            abort "Error: 'heroku' CLI is not installed or not found in PATH."
          end

          begin
            system("heroku", "labs:enable", "runtime-dyno-metadata", "--app", app_name)
          rescue Errno::ENOENT
            # Ignore if heroku CLI was not available for labs
          end

          puts "Finished setting up Heroku environment variables."
        end
      end
    end

    desc "Set Heroku environment variables from config/application.yml (alias for heroku:setup_env)"
    task :setup_heroku_env, [:app_name] => :environment do |_t, args|
      Rake::Task["heroku:setup_env"].invoke(args[:app_name])
    end
  RAKE

  create_file "lib/tasks/check_gem_versions.rake", <<~'RAKE', force: true
    # frozen_string_literal: true

    require "net/http"
    require "json"
    require "uri"
    require "rubygems"

    namespace :gems do
      desc "Check declared gems in Gemfile/Gemfile.lock against RubyGems.org for outdated versions"
      task :check_versions, [:gem_name] => :environment do |_t, args|
        root_dir = Rails.root

        lockfile_path = ENV["LOCKFILE"] || root_dir.join("Gemfile.lock").to_s
        gemfile_path = ENV["GEMFILE"] || root_dir.join("Gemfile").to_s
        concurrency = (ENV["CONCURRENCY"] || 10).to_i

        only_outdated = ENV["OUTDATED"].present? || ENV["ONLY_OUTDATED"].present?
        check_all = ENV["ALL"].present?

        target_gems = if args[:gem_name].present?
                        args.extras.unshift(args[:gem_name])
                      elsif ENV["GEMS"].present?
                        ENV["GEMS"].split(",").map(&:strip)
                      else
                        nil
                      end

        checker = GemVersionCheckerTask.new(
          lockfile_path: lockfile_path,
          gemfile_path: gemfile_path,
          concurrency: concurrency,
          target_gems: target_gems,
          check_all: check_all,
          only_outdated: only_outdated
        )

        checker.run
      end

      desc "Alias for gems:check_versions"
      task check: :check_versions
    end

    class GemVersionCheckerTask
      RUBYGEMS_API_URL = "https://rubygems.org/api/v1/versions/%s/latest.json"
      USER_AGENT = "GemVersionCheckerTask/1.0 (Ruby/#{RUBY_VERSION})"

      def initialize(lockfile_path:, gemfile_path:, concurrency: 10, target_gems: nil, check_all: false, only_outdated: false)
        @lockfile_path = lockfile_path
        @gemfile_path = gemfile_path
        @concurrency = concurrency
        @target_gems = target_gems
        @check_all = check_all
        @only_outdated = only_outdated
      end

      def run
        gems_to_check = select_gems
        if gems_to_check.empty?
          puts "No gems found to verify."
          return
        end

        scope_desc = if @target_gems
                       "specified (#{@target_gems.join(', ')})"
                     elsif @check_all
                       "all gems from Gemfile.lock (including transitive)"
                     else
                       "declared project gems"
                     end

        puts "🔍 Checking #{gems_to_check.size} #{scope_desc} against RubyGems.org..."
        puts "-" * 70

        results = check_gems_concurrently(gems_to_check)
        display_results(results)
      end

      private

      def select_gems
        specs = parse_lockfile_specs

        if @target_gems && !@target_gems.empty?
          return @target_gems.map do |name|
            { name: name, current_version: specs[name] }
          end
        end

        if @check_all
          specs.map { |name, ver| { name: name, current_version: ver } }.sort_by { |g| g[:name] }
        else
          declared_gems = parse_declared_gems
          declared_gems.map do |name|
            { name: name, current_version: specs[name] }
          end.sort_by { |g| g[:name] }
        end
      end

      def parse_declared_gems
        gems = []
        if File.exist?(@lockfile_path)
          content = File.read(@lockfile_path)
          if content =~ /^DEPENDENCIES\n(.*?)(?=\n\n|\Z)/m
            Regexp.last_match(1).each_line do |line|
              line = line.strip
              next if line.empty?
              gem_name = line.split.first.sub(/!\z/, "")
              gems << gem_name unless gems.include?(gem_name)
            end
          end
        end

        if gems.empty? && File.exist?(@gemfile_path)
          File.foreach(@gemfile_path) do |line|
            line = line.strip
            next if line.start_with?("#")
            if line =~ /^\s*gem\s+["']([^"']+)["']/
              name = Regexp.last_match(1)
              gems << name unless gems.include?(name)
            end
          end
        end

        gems
      end

      def parse_lockfile_specs
        specs = {}
        return specs unless File.exist?(@lockfile_path)

        File.foreach(@lockfile_path) do |line|
          if line =~ /^ {4}([a-zA-Z0-9_\-\.]+)\s+\(([0-9a-zA-Z\.\-]+)\)/
            name = Regexp.last_match(1)
            ver = Regexp.last_match(2)
            specs[name] ||= ver
          end
        end
        specs
      end

      def normalize_version(version_str)
        return nil if version_str.nil? || version_str.empty?
        version_str.to_s.sub(/-(?:arm|aarch64|x86_64|x86|darwin|linux|musl|java|universal).*\z/i, "")
      end

      def fetch_latest_version(gem_name)
        encoded_name = URI.encode_www_form_component(gem_name)
        uri = URI(format(RUBYGEMS_API_URL, encoded_name))
        req = Net::HTTP::Get.new(uri)
        req["User-Agent"] = USER_AGENT

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.open_timeout = 5
        http.read_timeout = 5

        res = http.request(req)
        case res
        when Net::HTTPSuccess
          data = JSON.parse(res.body)
          version = data["version"]
          version == "unknown" ? nil : version
        when Net::HTTPNotFound
          nil
        else
          :error
        end
      rescue StandardError
        :error
      end

      def check_gems_concurrently(gems)
        results = {}
        mutex = Mutex.new
        queue = Queue.new
        gems.each { |g| queue << g }

        worker_count = [@concurrency, gems.size].min
        worker_count = 1 if worker_count < 1

        threads = Array.new(worker_count) do
          Thread.new do
            until queue.empty?
              gem_info = begin
                queue.pop(true)
              rescue ThreadError
                nil
              end
              break unless gem_info

              name = gem_info[:name]
              latest = fetch_latest_version(name)
              mutex.synchronize do
                results[name] = gem_info.merge(latest_version: latest)
              end
            end
          end
        end

        threads.each(&:join)
        gems.map { |g| results[g[:name]] }
      end

      def compare_versions(current_str, latest_str)
        return :not_installed if current_str.nil? || current_str.empty?
        return :not_found if latest_str.nil?
        return :error if latest_str == :error

        norm_current = normalize_version(current_str)
        curr_v = Gem::Version.new(norm_current)
        late_v = Gem::Version.new(latest_str)

        curr_v >= late_v ? :up_to_date : :outdated
      rescue ArgumentError
        norm_current == latest_str ? :up_to_date : :outdated
      end

      def display_results(results)
        max_name_len = results.map { |r| r[:name].length }.max || 20
        up_to_date_count = 0
        outdated_count = 0
        other_count = 0

        results.each do |item|
          name = item[:name]
          current = item[:current_version]
          latest = item[:latest_version]
          status = compare_versions(current, latest)

          padded_name = name.ljust(max_name_len)

          case status
          when :up_to_date
            up_to_date_count += 1
            next if @only_outdated
            puts "#{padded_name}  ✅"
          when :outdated
            outdated_count += 1
            curr_display = current ? " (current: #{current})" : ""
            puts "#{padded_name}  latest version: #{latest}#{curr_display}"
          when :not_installed
            other_count += 1
            if latest
              puts "#{padded_name}  latest version: #{latest} (not installed locally)"
            else
              puts "#{padded_name}  ℹ️  not found on RubyGems (not installed)"
            end
          when :not_found
            other_count += 1
            puts "#{padded_name}  ℹ️  not available on RubyGems.org (git or private)"
          when :error
            other_count += 1
            puts "#{padded_name}  ⚠️  error querying RubyGems.org"
          end
        end

        puts "-" * 70
        summary = "Total: #{results.size} | Up to date: #{up_to_date_count} ✅ | Outdated: #{outdated_count}"
        summary += " | Other (git/private/error): #{other_count}" if other_count > 0
        puts summary
      end
    end
  RAKE
end
