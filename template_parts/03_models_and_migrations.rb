def add_models_and_migrations
  puts "\n==> 3. Creating Models and Migrations..."

  create_file "app/models/application_record.rb", <<~'RUBY', force: true
    class ApplicationRecord < ActiveRecord::Base
      primary_abstract_class
    end
  RUBY

  create_file "app/models/user.rb", <<~'RUBY', force: true
    class User < ApplicationRecord
      include PrefixedIds
      has_prefix_id :usr

      devise :database_authenticatable, :registerable,
             :recoverable, :rememberable, :validatable,
             :confirmable, :lockable, :trackable, :omniauthable,
             omniauth_providers: [ :google_oauth2, :facebook, :microsoft_graph ]

      has_many :identities, dependent: :destroy

      # Devise requires password by default; optional for social-only accounts
      def password_required?
        super && identities.empty?
      end

      # Core logic for Multi-Provider OAuth
      def self.from_omniauth(auth, current_user = nil)
        identity = Identity.find_by(provider: auth.provider, uid: auth.uid)

        if identity
          # Identity belongs to another account: conflict (do not merge automatically)
          return nil if current_user && identity.user != current_user

          return identity.user
        end

        # Logged-in user linking a new social account
        if current_user
          current_user.identities.create!(provider: auth.provider, uid: auth.uid, email: auth.info.email)
          return current_user
        end

        # Find by email returned by provider
        user = User.find_by(email: auth.info.email) if auth.info.email.present?

        # Create new user if it does not exist
        if user.nil?
          user = User.new(
            email: auth.info.email,
            name: auth.info.name,
            avatar_url: auth.info.image,
            password: Devise.friendly_token[0, 20]
          )
          begin
            user.save
          rescue ActiveRecord::RecordNotUnique
            user = User.find_by!(email: auth.info.email)
          end
        end

        if user.persisted?
          user.confirm if User.devise_modules.include?(:confirmable) && !user.confirmed?
          begin
            user.identities.create!(provider: auth.provider, uid: auth.uid, email: auth.info.email)
          rescue ActiveRecord::RecordNotUnique
            return Identity.find_by(provider: auth.provider, uid: auth.uid)&.user || user
          end
        end

        user
      end
    end
  RUBY

  create_file "app/models/identity.rb", <<~'RUBY', force: true
    class Identity < ApplicationRecord
      belongs_to :user

      validates :provider, presence: true
      validates :uid, presence: true, uniqueness: { scope: :provider }
    end
  RUBY

  create_file "db/migrate/20250416121353_devise_create_users.rb", <<~'RUBY', force: true
    # frozen_string_literal: true

    class DeviseCreateUsers < ActiveRecord::Migration[8.0]
      def change
        create_table :users do |t|
          ## Database authenticatable
          t.string :email,              null: false, default: ""
          t.string :encrypted_password, null: false, default: ""

          ## Recoverable
          t.string   :reset_password_token
          t.datetime :reset_password_sent_at

          ## Rememberable
          t.datetime :remember_created_at

          ## Trackable
          t.integer  :sign_in_count, default: 0, null: false
          t.datetime :current_sign_in_at
          t.datetime :last_sign_in_at
          t.string   :current_sign_in_ip
          t.string   :last_sign_in_ip

          ## Confirmable
          t.string   :confirmation_token
          t.datetime :confirmed_at
          t.datetime :confirmation_sent_at
          t.string   :unconfirmed_email

          ## Lockable
          t.integer  :failed_attempts, default: 0, null: false
          t.string   :unlock_token
          t.datetime :locked_at

          ## Profile
          t.string :name
          t.string :avatar_url

          t.timestamps null: false
        end

        add_index :users, :email,                unique: true
        add_index :users, :reset_password_token, unique: true
        add_index :users, :confirmation_token,   unique: true
        add_index :users, :unlock_token,         unique: true
      end
    end
  RUBY

  create_file "db/migrate/20250416121354_create_identities.rb", <<~'RUBY', force: true
    # frozen_string_literal: true

    class CreateIdentities < ActiveRecord::Migration[8.0]
      def change
        create_table :identities do |t|
          t.references :user, null: false, foreign_key: true
          t.string :provider, null: false
          t.string :uid, null: false
          t.string :email

          t.timestamps null: false
        end

        add_index :identities, [ :provider, :uid ], unique: true
      end
    end
  RUBY
end
