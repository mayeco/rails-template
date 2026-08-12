def add_controllers
  puts "\n==> 4. Generating Application and Devise Controllers..."

  create_file "app/controllers/application_controller.rb", <<~'RUBY', force: true
    class ApplicationController < ActionController::Base
      allow_browser versions: :modern
    end
  RUBY

  create_file "app/controllers/page_controller.rb", <<~'RUBY', force: true
    class PageController < ApplicationController
      before_action :authenticate_user!

      def index
        log_current_user
      end

      private

      def log_current_user
        Debugbar.msg("current_user:", { current_user: current_user }) if defined?(Debugbar)
      end
    end
  RUBY

  # Devise Controllers
  create_file "app/controllers/users/registrations_controller.rb", <<~'RUBY', force: true
    # frozen_string_literal: true

    class Users::RegistrationsController < Devise::RegistrationsController
      prepend_before_action :check_captcha, only: [:create]

      protected

      def after_inactive_sign_up_path_for(resource)
        new_user_session_path
      end

      def check_captcha
        return if verify_recaptcha(action: "registration")

        self.resource = resource_class.new(sign_up_params)
        resource.validate
        set_minimum_password_length
        flash.now[:alert] = t("devise.failure.recaptcha_failed")
        render :new, status: :unprocessable_entity
      end
    end
  RUBY

  create_file "app/controllers/users/sessions_controller.rb", <<~'RUBY', force: true
    # frozen_string_literal: true

    class Users::SessionsController < Devise::SessionsController
      prepend_before_action :check_captcha, only: [:create]

      def check_captcha
        return if verify_recaptcha(action: "login")

        self.resource = resource_class.new(sign_in_params)
        flash.now[:alert] = t("devise.failure.recaptcha_failed")
        render :new, status: :unprocessable_entity
      end
    end
  RUBY

  create_file "app/controllers/users/omniauth_callbacks_controller.rb", <<~'RUBY', force: true
    # frozen_string_literal: true

    class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
      layout false

      before_action :initialize_user_from_auth_email, except: [:failure]

      def initialize_user_from_auth_email
        if auth_hash.blank? || auth_hash.info&.email.blank?
          return redirect_to new_user_session_path, alert: "Authentication failed: missing email from provider."
        end

        info = auth_hash.info
        if info.respond_to?(:email_verified) && info.email_verified == false
          return redirect_to new_user_session_path, alert: t("devise.failure.unverified_oauth_email")
        end

        @user = User.from_omniauth_email(auth_hash)
        return redirect_to new_user_session_path, alert: "Authentication failed." if @user.nil?

        @user.confirm if User.devise_modules.include?(:confirmable) && !@user.confirmed?
        user_omniauth_providers

        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication
        else
          redirect_to new_user_registration_path, alert: @user.errors.full_messages.to_sentence
        end
      end

      def user_omniauth_providers
        provider = auth_hash["provider"]
        @user.provider ||= provider
        @user.uid ||= auth_hash[:uid]
        if @user.omniauth_providers[provider].nil?
          @user.omniauth_providers[provider] = {
            "uid" => auth_hash[:uid],
            "email" => auth_hash.info&.email
          }
        end
        begin
          @user.save
        rescue ActiveRecord::RecordNotUnique
          @user = User.find_by!(email: auth_hash.info.email)
          @user.provider ||= provider
          @user.uid ||= auth_hash[:uid]
          if @user.omniauth_providers[provider].nil?
            @user.omniauth_providers[provider] = {
              "uid" => auth_hash[:uid],
              "email" => auth_hash.info&.email
            }
          end
          @user.save
        end
      end

      def google_oauth2; end
      def facebook; end
      def microsoft_graph; end

      def failure
        super
      end

      private

      def auth_hash
        request.env["omniauth.auth"]
      end
    end
  RUBY
end
