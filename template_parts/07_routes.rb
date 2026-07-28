def add_routes
  puts "\n==> 7. Configuring Routes (config/routes.rb)..."

  create_file "config/routes.rb", <<~'RUBY', force: true
    Rails.application.routes.draw do
      devise_for :users, controllers: {
        omniauth_callbacks: "users/omniauth_callbacks",
        registrations: "users/registrations",
        sessions: "users/sessions"
      }

      mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development? && defined?(LetterOpenerWeb)
      mount MissionControl::Jobs::Engine, at: "/jobs" if Rails.env.development? && defined?(MissionControl::Jobs)

      get "up" => "rails/health#show", as: :rails_health_check

      root "page#index"
    end
  RUBY
end
