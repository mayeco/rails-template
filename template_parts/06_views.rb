def add_views
  puts "\n==> 6. Creating Views and Layouts..."

  create_file "app/views/layouts/application.html.erb", <<~'ERB', force: true
    <!DOCTYPE html>
    <html lang="es" data-bs-theme="light">
    <head>
      <title><%= content_for(:title) || "Agentpl" %></title>
      <meta name="viewport" content="width=device-width,initial-scale=1">
      <meta name="apple-mobile-web-app-capable" content="yes">
      <meta name="mobile-web-app-capable" content="yes">
      <%= csrf_meta_tags %>
      <%= csp_meta_tag %>

      <%= yield :head %>

      <link rel="icon" href="/icon.png" type="image/png">
      <link rel="icon" href="/icon.svg" type="image/svg+xml">
      <link rel="apple-touch-icon" href="/icon.png">

      <link rel="stylesheet" href="https://unpkg.com/@webpixels/css/dist/index.css">
      <link rel="stylesheet" href="https://unpkg.com/@webpixels/css/dist/themes/elegant.css">
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

      <%= stylesheet_link_tag :app, "data-turbo-track": "reload" %>

      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
      <%= javascript_importmap_tags %>
      <%= debugbar_head if defined? Debugbar %>
      <%= Sentry.get_trace_propagation_meta.html_safe if defined?(Sentry) %>
    </head>

    <body class="theme-elegant">
    <div class="container">
      <%= render_flash_messages if respond_to?(:render_flash_messages) %>
      <%= yield %>

      <% if user_signed_in? %>
        <%= button_to destroy_user_session_path, method: :delete, data: { turbo: false }, class: "btn btn-sm d-inline-flex btn-neutral text-danger" do %>
          <span class="pe-2"><i class="bi bi-trash"></i></span> Log out
        <% end %>
      <% end %>
    </div>
    <%= debugbar_body if defined? Debugbar %>
    </body>
    </html>
  ERB

  create_file "app/views/page/index.html.erb", <<~'ERB', force: true
    <h1>Page#index</h1>
    <p>Find me in app/views/page/index.html.erb</p>
  ERB

  # Devise Views
  create_file "app/views/devise/sessions/new.html.erb", <<~'ERB', force: true
    <h2>Log in</h2>

    <%= simple_form_for(resource, as: resource_name, url: session_path(resource_name), data: { turbo: false }) do |f| %>
      <%= recaptcha_v3(action: "LOGIN") if respond_to?(:recaptcha_v3) %>

      <div class="form-inputs">
        <%= f.input :email,
                    required: false,
                    autofocus: true,
                    input_html: { autocomplete: "email" } %>
        <%= f.input :password,
                    required: false,
                    input_html: { autocomplete: "current-password" } %>
        <%= f.input :remember_me, as: :boolean if devise_mapping.rememberable? %>
      </div>

      <div class="form-actions">
        <%= f.button :submit, "Log in" %>
      </div>
    <% end %>

    <%= render "devise/shared/links" %>
  ERB

  create_file "app/views/devise/registrations/new.html.erb", <<~'ERB', force: true
    <h2>Sign up</h2>

    <%= simple_form_for(resource, as: resource_name, url: registration_path(resource_name), data: { turbo: false }) do |f| %>
      <%= recaptcha_v3(action: "REGISTRATION") if respond_to?(:recaptcha_v3) %>

      <div class="form-inputs">
        <%= f.input :email,
                    required: true,
                    autofocus: true,
                    input_html: { autocomplete: "email" }%>
        <%= f.input :password,
                    required: true,
                    hint: ("#{@minimum_password_length} characters minimum" if @minimum_password_length),
                    input_html: { autocomplete: "new-password" } %>
        <%= f.input :password_confirmation,
                    required: true,
                    input_html: { autocomplete: "new-password" } %>
      </div>

      <div class="form-actions">
        <%= f.button :submit, "Sign up" %>
      </div>
    <% end %>

    <%= render "devise/shared/links" %>
  ERB

  create_file "app/views/devise/registrations/edit.html.erb", <<~'ERB', force: true
    <h2>Edit <%= resource_name.to_s.humanize %></h2>

    <%= simple_form_for(resource, as: resource_name, url: registration_path(resource_name), html: { method: :put }) do |f| %>
      <%= f.error_notification %>

      <div class="form-inputs">
        <%= f.input :email, required: true, autofocus: true %>

        <% if devise_mapping.confirmable? && resource.pending_reconfirmation? %>
          <p>Currently waiting confirmation for: <%= resource.unconfirmed_email %></p>
        <% end %>

        <%= f.input :password,
                    hint: "leave it blank if you don't want to change it",
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

      <div class="form-actions">
        <%= f.button :submit, "Update" %>
      </div>
    <% end %>

    <h3>Cancel my account</h3>

    <div>Unhappy? <%= button_to "Cancel my account", registration_path(resource_name), data: { confirm: "Are you sure?", turbo_confirm: "Are you sure?" }, method: :delete %></div>

    <%= link_to "Back", :back %>
  ERB

  create_file "app/views/devise/passwords/new.html.erb", <<~'ERB', force: true
    <h2>Forgot your password?</h2>

    <%= simple_form_for(resource, as: resource_name, url: password_path(resource_name), html: { method: :post }) do |f| %>
      <%= f.error_notification %>

      <div class="form-inputs">
        <%= f.input :email,
                    required: true,
                    autofocus: true,
                    input_html: { autocomplete: "email" } %>
      </div>

      <div class="form-actions">
        <%= f.button :submit, "Send me reset password instructions" %>
      </div>
    <% end %>

    <%= render "devise/shared/links" %>
  ERB

  create_file "app/views/devise/passwords/edit.html.erb", <<~'ERB', force: true
    <h2>Change your password</h2>

    <%= simple_form_for(resource, as: resource_name, url: password_path(resource_name), html: { method: :put }) do |f| %>
      <%= f.error_notification %>

      <%= f.input :reset_password_token, as: :hidden %>
      <%= f.full_error :reset_password_token %>

      <div class="form-inputs">
        <%= f.input :password,
                    label: "New password",
                    required: true,
                    autofocus: true,
                    hint: ("#{@minimum_password_length} characters minimum" if @minimum_password_length),
                    input_html: { autocomplete: "new-password" } %>
        <%= f.input :password_confirmation,
                    label: "Confirm your new password",
                    required: true,
                    input_html: { autocomplete: "new-password" } %>
      </div>

      <div class="form-actions">
        <%= f.button :submit, "Change my password" %>
      </div>
    <% end %>

    <%= render "devise/shared/links" %>
  ERB

  create_file "app/views/devise/confirmations/new.html.erb", <<~'ERB', force: true
    <h2>Resend confirmation instructions</h2>

    <%= simple_form_for(resource, as: resource_name, url: confirmation_path(resource_name), html: { method: :post }) do |f| %>
      <%= f.error_notification %>
      <%= f.full_error :confirmation_token %>

      <div class="form-inputs">
        <%= f.input :email,
                    required: true,
                    autofocus: true,
                    value: (resource.pending_reconfirmation? ? resource.unconfirmed_email : resource.email),
                    input_html: { autocomplete: "email" } %>
      </div>

      <div class="form-actions">
        <%= f.button :submit, "Resend confirmation instructions" %>
      </div>
    <% end %>

    <%= render "devise/shared/links" %>
  ERB

  create_file "app/views/devise/unlocks/new.html.erb", <<~'ERB', force: true
    <h2>Resend unlock instructions</h2>

    <%= simple_form_for(resource, as: resource_name, url: unlock_path(resource_name), html: { method: :post }) do |f| %>
      <%= f.error_notification %>
      <%= f.full_error :unlock_token %>

      <div class="form-inputs">
        <%= f.input :email,
                    required: true,
                    autofocus: true,
                    input_html: { autocomplete: "email" } %>
      </div>

      <div class="form-actions">
        <%= f.button :submit, "Resend unlock instructions" %>
      </div>
    <% end %>

    <%= render "devise/shared/links" %>
  ERB

  create_file "app/views/devise/shared/_links.html.erb", <<~'ERB', force: true
    <%- if controller_name != 'sessions' %>
      <%= link_to "Log in", new_session_path(resource_name), data: { turbo: false } %><br/>
    <% end %>

    <%- if devise_mapping.registerable? && controller_name != 'registrations' %>
      <%= link_to "Sign up", new_registration_path(resource_name), data: { turbo: false } %><br/>
    <% end %>

    <%- if devise_mapping.recoverable? && controller_name != 'passwords' && controller_name != 'registrations' %>
      <%= link_to "Forgot your password?", new_password_path(resource_name) %><br/>
    <% end %>

    <%- if devise_mapping.confirmable? && controller_name != 'confirmations' %>
      <%= link_to "Didn't receive confirmation instructions?", new_confirmation_path(resource_name) %><br/>
    <% end %>

    <%- if devise_mapping.lockable? && resource_class.unlock_strategy_enabled?(:email) && controller_name != 'unlocks' %>
      <%= link_to "Didn't receive unlock instructions?", new_unlock_path(resource_name) %><br/>
    <% end %>

    <%- if devise_mapping.omniauthable? %>
      <div class="text-center mt-6 mb-3 text-muted small">
        <%- if controller_name == 'sessions' %>
          or log in with
        <% else %>
          or create your account with
        <% end %>
      </div>

      <div class="text-center mb-6 d-flex gap-2 small">
        <%- resource_class.omniauth_providers.each do |provider| %>
          <%= button_to omniauth_authorize_path(resource_name, provider), data: { turbo: false }, class: "btn btn-sm btn-neutral flex-grow-1", form_class: "d-flex flex-grow-1" do %>
            <i class="bi bi-<%= omniauth_icon(provider) %>"></i>
          <% end %>
        <% end %>
      </div>
    <% end %>
  ERB

  create_file "app/views/devise/shared/_error_messages.html.erb", <<~'ERB', force: true
    <% if resource.errors.any? %>
      <div id="error_explanation" data-turbo-cache="false">
        <h2>
          <%= I18n.t("errors.messages.not_saved",
                     count: resource.errors.count,
                     resource: resource.class.model_name.human.downcase)
           %>
        </h2>
        <ul>
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
