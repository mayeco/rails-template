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
      prepend_before_action :check_captcha, only: [ :create ]

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
      prepend_before_action :check_captcha, only: [ :create ]

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

      def handle_callback
        if auth_hash.blank? || auth_hash.info&.email.blank?
          return redirect_to new_user_session_path, alert: t("devise.failure.missing_oauth_email")
        end

        info = auth_hash.info
        if info.respond_to?(:email_verified) && info.email_verified == false
          return redirect_to new_user_session_path, alert: t("devise.failure.unverified_oauth_email")
        end

        @user = User.from_omniauth(auth_hash, current_user)

        if @user&.persisted?
          if current_user
            flash[:notice] = t("devise.omniauth_callbacks.linked", kind: auth_hash.provider.humanize)
            redirect_to edit_user_registration_path
          else
            set_flash_message(:notice, :success, kind: auth_hash.provider.humanize) if is_navigational_format?
            sign_in_and_redirect @user, event: :authentication
          end
        else
          flash[:alert] = t("devise.failure.oauth_auth_failed")
          redirect_to new_user_session_path
        end
      end

      alias_method :google_oauth2, :handle_callback
      alias_method :facebook, :handle_callback
      alias_method :microsoft_graph, :handle_callback

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
