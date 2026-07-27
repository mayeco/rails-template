def add_routes
  puts "\n==> 7. Configuring Routes (config/routes.rb)..."

  create_file "config/routes.rb", <<~'RUBY', force: true
    Rails.application.routes.draw do
      devise_for :users, controllers: {
        confirmations: "users/confirmations",
        omniauth_callbacks: "users/omniauth_callbacks",
        passwords: "users/passwords",
        registrations: "users/registrations",
        sessions: "users/sessions",
        unlocks: "users/unlocks"
      }

      mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
      mount MissionControl::Jobs::Engine, at: "/jobs"

      get "up" => "rails/health#show", as: :rails_health_check

      root "page#index"
    end
  RUBY
end
