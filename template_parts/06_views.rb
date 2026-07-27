def add_views
  puts "\n==> 6. Creating Views and Layouts..."

  create_file "app/views/layouts/application.html.erb", <<~'ERB', force: true
    <!DOCTYPE html>
    <html>
    <head>
      <title><%= content_for(:title) || Rails.application.class.module_parent_name.titleize %></title>
      <meta name="viewport" content="width=device-width,initial-scale=1">
      <meta name="apple-mobile-web-app-capable" content="yes">
      <meta name="mobile-web-app-capable" content="yes">
      <%= csrf_meta_tags %>
      <%= csp_meta_tag %>

      <%= yield :head %>

      <link rel="icon" href="/icon.png" type="image/png">
      <link rel="icon" href="/icon.svg" type="image/svg+xml">
      <link rel="apple-touch-icon" href="/icon.png">

      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
      <%= stylesheet_link_tag :app, "data-turbo-track": "reload" %>

      <%= debugbar_head if defined? Debugbar %>
    </head>

    <body class="bg-slate-50 min-h-screen flex flex-col font-sans antialiased text-slate-800">
      <main class="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 my-auto py-8">
        <%= render_flash_messages if respond_to?(:render_flash_messages) %>
        <%= yield %>

        <% if user_signed_in? %>
          <div class="text-center mt-6">
            <%= button_to destroy_user_session_path, method: :delete, data: { turbo: false }, class: "inline-flex items-center gap-2 px-3 py-1.5 text-sm font-medium text-red-600 border border-red-200 rounded-md hover:bg-red-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 transition" do %>
              <i class="bi bi-box-arrow-right"></i> Log out
            <% end %>
          </div>
        <% end %>
      </main>
      <%= debugbar_body if defined? Debugbar %>
    </body>
    </html>
  ERB

  create_file "app/views/page/index.html.erb", <<~'ERB', force: true
    <div class="max-w-2xl mx-auto text-center py-12">
      <h1 class="text-4xl font-extrabold tracking-tight text-slate-900 sm:text-5xl mb-4">
        <%= Rails.application.class.module_parent_name.titleize %>
      </h1>
      <p class="text-lg text-slate-600 mb-8">
        Welcome back, <span class="font-semibold text-slate-800"><%= current_user.email %></span>!
      </p>
      <div class="bg-white shadow-sm border border-slate-200 rounded-xl p-6">
        <p class="text-sm text-slate-500">
          Find this view in <code class="bg-slate-100 text-slate-800 px-2 py-0.5 rounded text-xs">app/views/page/index.html.erb</code>
        </p>
      </div>
    </div>
  ERB

  # Devise Views
  create_file "app/views/devise/sessions/new.html.erb", <<~'ERB', force: true
    <div class="max-w-md mx-auto">
      <div class="bg-white shadow-md border border-slate-200 rounded-2xl p-6 sm:p-8">
        <div class="text-center mb-6">
          <h2 class="text-2xl font-bold text-slate-900">Welcome back</h2>
          <p class="text-sm text-slate-500 mt-1">Please log in to your account</p>
        </div>

        <%= simple_form_for(resource, as: resource_name, url: session_path(resource_name), data: { turbo: false }) do |f| %>
          <%= recaptcha_v3(action: "LOGIN") if respond_to?(:recaptcha_v3) %>

          <div class="space-y-4">
            <%= f.input :email,
                        required: false,
                        autofocus: true,
                        input_html: { autocomplete: "email" } %>

            <%= f.input :password,
                        required: false,
                        input_html: { autocomplete: "current-password" } %>

            <% if devise_mapping.rememberable? %>
              <%= f.input :remember_me, as: :boolean %>
            <% end %>
          </div>

          <div class="mt-6">
            <%= f.button :submit, "Log in", class: "w-full py-2.5 px-4 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2" %>
          </div>
        <% end %>

        <%= render "devise/shared/links" %>
      </div>
    </div>
  ERB

  create_file "app/views/devise/registrations/new.html.erb", <<~'ERB', force: true
    <div class="max-w-md mx-auto">
      <div class="bg-white shadow-md border border-slate-200 rounded-2xl p-6 sm:p-8">
        <div class="text-center mb-6">
          <h2 class="text-2xl font-bold text-slate-900">Create an account</h2>
          <p class="text-sm text-slate-500 mt-1">Sign up to get started</p>
        </div>

        <%= simple_form_for(resource, as: resource_name, url: registration_path(resource_name), data: { turbo: false }) do |f| %>
          <%= recaptcha_v3(action: "REGISTRATION") if respond_to?(:recaptcha_v3) %>

          <div class="space-y-4">
            <%= f.input :email,
                        required: true,
                        autofocus: true,
                        input_html: { autocomplete: "email" } %>

            <%= f.input :password,
                        required: true,
                        hint: ("#{@minimum_password_length} characters minimum" if @minimum_password_length),
                        input_html: { autocomplete: "new-password" } %>

            <%= f.input :password_confirmation,
                        required: true,
                        input_html: { autocomplete: "new-password" } %>
          </div>

          <div class="mt-6">
            <%= f.button :submit, "Sign up", class: "w-full py-2.5 px-4 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2" %>
          </div>
        <% end %>

        <%= render "devise/shared/links" %>
      </div>
    </div>
  ERB

  create_file "app/views/devise/registrations/edit.html.erb", <<~'ERB', force: true
    <div class="max-w-lg mx-auto">
      <div class="bg-white shadow-md border border-slate-200 rounded-2xl p-6 sm:p-8">
        <div class="mb-6">
          <h2 class="text-2xl font-bold text-slate-900">Edit Account</h2>
          <p class="text-sm text-slate-500 mt-1">Update your profile settings and password</p>
        </div>

        <%= simple_form_for(resource, as: resource_name, url: registration_path(resource_name), html: { method: :put }) do |f| %>
          <%= f.error_notification %>

          <div class="space-y-4">
            <%= f.input :email, required: true, autofocus: true %>

            <% if devise_mapping.confirmable? && resource.pending_reconfirmation? %>
              <div class="p-3 bg-blue-50 border border-blue-200 text-blue-800 rounded-lg text-xs">
                Currently waiting confirmation for: <strong><%= resource.unconfirmed_email %></strong>
              </div>
            <% end %>

            <%= f.input :password,
                        hint: "leave blank if you don't want to change it",
                        required: false,
                        input_html: { autocomplete: "new-password" } %>

            <%= f.input :password_confirmation,
                        required: false,
                        input_html: { autocomplete: "new-password" } %>

            <%= f.input :current_password,
                        hint: "we need your current password to confirm your changes",
                        required: true,
                        input_html: { autocomplete: "current-password" } %>
          </div>

          <div class="flex items-center justify-between mt-6">
            <%= link_to "Back", :back, class: "px-4 py-2 border border-slate-300 text-slate-700 font-medium rounded-lg text-sm hover:bg-slate-50 transition" %>
            <%= f.button :submit, "Update Profile", class: "py-2.5 px-5 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2" %>
          </div>
        <% end %>

        <div class="mt-8 pt-6 border-t border-slate-200">
          <div class="bg-red-50 border border-red-200 rounded-xl p-4 flex items-center justify-between">
            <div>
              <h3 class="text-sm font-semibold text-red-900">Cancel my account</h3>
              <p class="text-xs text-red-600 mt-0.5">Permanently delete your account and data.</p>
            </div>
            <%= button_to "Delete Account", registration_path(resource_name), data: { confirm: "Are you sure?", turbo_confirm: "Are you sure?" }, method: :delete, class: "px-3 py-1.5 bg-red-600 hover:bg-red-700 text-white text-xs font-semibold rounded-md shadow-sm transition" %>
          </div>
        </div>
      </div>
    </div>
  ERB

  create_file "app/views/devise/passwords/new.html.erb", <<~'ERB', force: true
    <div class="max-w-md mx-auto">
      <div class="bg-white shadow-md border border-slate-200 rounded-2xl p-6 sm:p-8">
        <div class="text-center mb-6">
          <h2 class="text-2xl font-bold text-slate-900">Forgot password?</h2>
          <p class="text-sm text-slate-500 mt-1">Enter your email address to reset your password</p>
        </div>

        <%= simple_form_for(resource, as: resource_name, url: password_path(resource_name), html: { method: :post }) do |f| %>
          <%= f.error_notification %>

          <div class="space-y-4">
            <%= f.input :email,
                        required: true,
                        autofocus: true,
                        input_html: { autocomplete: "email" } %>
          </div>

          <div class="mt-6">
            <%= f.button :submit, "Send reset instructions", class: "w-full py-2.5 px-4 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2" %>
          </div>
        <% end %>

        <%= render "devise/shared/links" %>
      </div>
    </div>
  ERB

  create_file "app/views/devise/passwords/edit.html.erb", <<~'ERB', force: true
    <div class="max-w-md mx-auto">
      <div class="bg-white shadow-md border border-slate-200 rounded-2xl p-6 sm:p-8">
        <div class="text-center mb-6">
          <h2 class="text-2xl font-bold text-slate-900">Change password</h2>
          <p class="text-sm text-slate-500 mt-1">Set a new password for your account</p>
        </div>

        <%= simple_form_for(resource, as: resource_name, url: password_path(resource_name), html: { method: :put }) do |f| %>
          <%= f.error_notification %>

          <%= f.input :reset_password_token, as: :hidden %>
          <%= f.full_error :reset_password_token %>

          <div class="space-y-4">
            <%= f.input :password,
                        label: "New password",
                        required: true,
                        autofocus: true,
                        hint: ("#{@minimum_password_length} characters minimum" if @minimum_password_length),
                        input_html: { autocomplete: "new-password" } %>

            <%= f.input :password_confirmation,
                        label: "Confirm new password",
                        required: true,
                        input_html: { autocomplete: "new-password" } %>
          </div>

          <div class="mt-6">
            <%= f.button :submit, "Change my password", class: "w-full py-2.5 px-4 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2" %>
          </div>
        <% end %>

        <%= render "devise/shared/links" %>
      </div>
    </div>
  ERB

  create_file "app/views/devise/confirmations/new.html.erb", <<~'ERB', force: true
    <div class="max-w-md mx-auto">
      <div class="bg-white shadow-md border border-slate-200 rounded-2xl p-6 sm:p-8">
        <div class="text-center mb-6">
          <h2 class="text-2xl font-bold text-slate-900">Resend confirmation</h2>
          <p class="text-sm text-slate-500 mt-1">Request a new account confirmation email</p>
        </div>

        <%= simple_form_for(resource, as: resource_name, url: confirmation_path(resource_name), html: { method: :post }) do |f| %>
          <%= f.error_notification %>
          <%= f.full_error :confirmation_token %>

          <div class="space-y-4">
            <%= f.input :email,
                        required: true,
                        autofocus: true,
                        value: (resource.pending_reconfirmation? ? resource.unconfirmed_email : resource.email),
                        input_html: { autocomplete: "email" } %>
          </div>

          <div class="mt-6">
            <%= f.button :submit, "Resend instructions", class: "w-full py-2.5 px-4 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2" %>
          </div>
        <% end %>

        <%= render "devise/shared/links" %>
      </div>
    </div>
  ERB

  create_file "app/views/devise/unlocks/new.html.erb", <<~'ERB', force: true
    <div class="max-w-md mx-auto">
      <div class="bg-white shadow-md border border-slate-200 rounded-2xl p-6 sm:p-8">
        <div class="text-center mb-6">
          <h2 class="text-2xl font-bold text-slate-900">Resend unlock</h2>
          <p class="text-sm text-slate-500 mt-1">Request instructions to unlock your account</p>
        </div>

        <%= simple_form_for(resource, as: resource_name, url: unlock_path(resource_name), html: { method: :post }) do |f| %>
          <%= f.error_notification %>
          <%= f.full_error :unlock_token %>

          <div class="space-y-4">
            <%= f.input :email,
                        required: true,
                        autofocus: true,
                        input_html: { autocomplete: "email" } %>
          </div>

          <div class="mt-6">
            <%= f.button :submit, "Resend unlock instructions", class: "w-full py-2.5 px-4 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2" %>
          </div>
        <% end %>

        <%= render "devise/shared/links" %>
      </div>
    </div>
  ERB

  create_file "app/views/devise/shared/_links.html.erb", <<~'ERB', force: true
    <div class="mt-6 pt-4 border-t border-slate-200 text-center text-xs text-slate-500 space-y-2">
      <%- if controller_name != 'sessions' %>
        <div>Already have an account? <%= link_to "Log in", new_session_path(resource_name), data: { turbo: false }, class: "font-semibold text-indigo-600 hover:text-indigo-500" %></div>
      <% end %>

      <%- if devise_mapping.registerable? && controller_name != 'registrations' %>
        <div>Don't have an account? <%= link_to "Sign up", new_registration_path(resource_name), data: { turbo: false }, class: "font-semibold text-indigo-600 hover:text-indigo-500" %></div>
      <% end %>

      <%- if devise_mapping.recoverable? && controller_name != 'passwords' && controller_name != 'registrations' %>
        <div><%= link_to "Forgot your password?", new_password_path(resource_name), class: "hover:underline" %></div>
      <% end %>

      <%- if devise_mapping.confirmable? && controller_name != 'confirmations' %>
        <div><%= link_to "Didn't receive confirmation instructions?", new_confirmation_path(resource_name), class: "hover:underline" %></div>
      <% end %>

      <%- if devise_mapping.lockable? && resource_class.unlock_strategy_enabled?(:email) && controller_name != 'unlocks' %>
        <div><%= link_to "Didn't receive unlock instructions?", new_unlock_path(resource_name), class: "hover:underline" %></div>
      <% end %>
    </div>

    <%- if devise_mapping.omniauthable? %>
      <div class="mt-6">
        <div class="relative flex py-2 items-center">
          <div class="flex-grow border-t border-slate-200"></div>
          <span class="flex-shrink mx-3 text-xs text-slate-400 uppercase tracking-wider">
            <%- if controller_name == 'sessions' %>
              or log in with
            <%- else %>
              or create account with
            <% end %>
          </span>
          <div class="flex-grow border-t border-slate-200"></div>
        </div>

        <div class="mt-3 flex gap-2">
          <%- resource_class.omniauth_providers.each do |provider| %>
            <%= button_to omniauth_authorize_path(resource_name, provider), data: { turbo: false }, class: "flex-1 inline-flex justify-center items-center gap-2 py-2 px-3 border border-slate-300 rounded-lg shadow-sm bg-white text-xs font-medium text-slate-700 hover:bg-slate-50 transition focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2", form_class: "flex-1" do %>
              <i class="bi bi-<%= omniauth_icon(provider) %> text-base"></i>
              <span class="capitalize"><%= provider.to_s.split('_').first %></span>
            <% end %>
          <% end %>
        </div>
      </div>
    <% end %>
  ERB

  create_file "app/views/devise/shared/_error_messages.html.erb", <<~'ERB', force: true
    <% if resource.errors.any? %>
      <div id="error_explanation" class="mb-4 p-4 bg-red-50 border border-red-200 rounded-xl text-red-900" data-turbo-cache="false">
        <h3 class="text-sm font-semibold mb-2">
          <%= I18n.t("errors.messages.not_saved",
                     count: resource.errors.count,
                     resource: resource.class.model_name.human.downcase)
           %>
        </h3>
        <ul class="list-disc list-inside text-xs space-y-1 text-red-700">
          <% resource.errors.full_messages.each do |message| %>
            <li><%= message %></li>
          <% end %>
        </ul>
      </div>
    <% end %>
  ERB

  create_file "app/views/devise/mailer/confirmation_instructions.html.erb", <<~'ERB', force: true
    <p>Welcome <%= @email %>!</p>
    <p>You can confirm your account email through the link below:</p>
    <p><%= link_to 'Confirm my account', confirmation_url(@resource, confirmation_token: @token) %></p>
  ERB

  create_file "app/views/devise/mailer/email_changed.html.erb", <<~'ERB', force: true
    <p>Hello <%= @email %>!</p>

    <% if @resource.try(:unconfirmed_email?) %>
      <p>We're contacting you to notify you that your email is being changed to <%= @resource.unconfirmed_email %>.</p>
    <% else %>
      <p>We're contacting you to notify you that your email has been changed to <%= @resource.email %>.</p>
    <% end %>
  ERB

  create_file "app/views/devise/mailer/password_change.html.erb", <<~'ERB', force: true
    <p>Hello <%= @resource.email %>!</p>
    <p>We're contacting you to notify you that your password has been changed.</p>
  ERB

  create_file "app/views/devise/mailer/reset_password_instructions.html.erb", <<~'ERB', force: true
    <p>Hello <%= @resource.email %>!</p>
    <p>Someone has requested a link to change your password. You can do this through the link below.</p>
    <p><%= link_to 'Change my password', edit_password_url(@resource, reset_password_token: @token) %></p>
    <p>If you didn't request this, please ignore this email.</p>
    <p>Your password won't change until you access the link above and create a new one.</p>
  ERB

  create_file "app/views/devise/mailer/unlock_instructions.html.erb", <<~'ERB', force: true
    <p>Hello <%= @resource.email %>!</p>
    <p>Your account has been locked due to an excessive number of unsuccessful sign in attempts.</p>
    <p>Click the link below to unlock your account:</p>
    <p><%= link_to 'Unlock my account', unlock_url(@resource, unlock_token: @token) %></p>
  ERB
end
