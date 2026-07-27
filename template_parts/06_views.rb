def add_views
  puts "\n==> 6. Creating Views and Layouts..."

  create_file "app/views/layouts/application.html.erb", <<~'ERB', force: true
    <!DOCTYPE html>
    <html lang="es" data-bs-theme="light">
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

      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">

      <%= stylesheet_link_tag :app, "data-turbo-track": "reload" %>

      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
      <%= debugbar_head if defined? Debugbar %>
    </head>

    <body class="bg-body-tertiary min-vh-100 d-flex flex-column">
      <main class="container my-auto py-5">
        <%= render_flash_messages if respond_to?(:render_flash_messages) %>
        <%= yield %>

        <% if user_signed_in? %>
          <div class="text-center mt-4">
            <%= button_to destroy_user_session_path, method: :delete, data: { turbo: false }, class: "btn btn-sm btn-outline-danger d-inline-flex align-items-center gap-2" do %>
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
    <div class="row justify-content-center">
      <div class="col-12 col-md-10 col-lg-8 text-center py-5">
        <h1 class="display-5 fw-bold mb-3"><%= Rails.application.class.module_parent_name.titleize %></h1>
        <p class="lead text-secondary mb-4">Welcome back, <strong><%= current_user.email %></strong>!</p>
        <div class="card shadow-sm border-0 rounded-3 p-4">
          <p class="mb-0 text-muted">Find this view in <code>app/views/page/index.html.erb</code></p>
        </div>
      </div>
    </div>
  ERB

  # Devise Views
  create_file "app/views/devise/sessions/new.html.erb", <<~'ERB', force: true
    <div class="row justify-content-center">
      <div class="col-12 col-sm-10 col-md-8 col-lg-5">
        <div class="card shadow-sm border-0 rounded-3">
          <div class="card-body p-4 p-md-5">
            <div class="text-center mb-4">
              <h2 class="fw-bold h3 mb-1">Welcome back</h2>
              <p class="text-secondary small">Please log in to your account</p>
            </div>

            <%= simple_form_for(resource, as: resource_name, url: session_path(resource_name), data: { turbo: false }) do |f| %>
              <%= recaptcha_v3(action: "LOGIN") if respond_to?(:recaptcha_v3) %>

              <div class="mb-3">
                <%= f.input :email,
                            required: false,
                            autofocus: true,
                            input_html: { autocomplete: "email", class: "form-control" } %>
              </div>

              <div class="mb-3">
                <%= f.input :password,
                            required: false,
                            input_html: { autocomplete: "current-password", class: "form-control" } %>
              </div>

              <% if devise_mapping.rememberable? %>
                <div class="mb-3 form-check">
                  <%= f.input :remember_me, as: :boolean, wrapper_html: { class: "mb-0" } %>
                </div>
              <% end %>

              <div class="d-grid mt-4">
                <%= f.button :submit, "Log in", class: "btn btn-primary btn-lg" %>
              </div>
            <% end %>

            <%= render "devise/shared/links" %>
          </div>
        </div>
      </div>
    </div>
  ERB

  create_file "app/views/devise/registrations/new.html.erb", <<~'ERB', force: true
    <div class="row justify-content-center">
      <div class="col-12 col-sm-10 col-md-8 col-lg-5">
        <div class="card shadow-sm border-0 rounded-3">
          <div class="card-body p-4 p-md-5">
            <div class="text-center mb-4">
              <h2 class="fw-bold h3 mb-1">Create an account</h2>
              <p class="text-secondary small">Sign up to get started</p>
            </div>

            <%= simple_form_for(resource, as: resource_name, url: registration_path(resource_name), data: { turbo: false }) do |f| %>
              <%= recaptcha_v3(action: "REGISTRATION") if respond_to?(:recaptcha_v3) %>

              <div class="mb-3">
                <%= f.input :email,
                            required: true,
                            autofocus: true,
                            input_html: { autocomplete: "email", class: "form-control" } %>
              </div>

              <div class="mb-3">
                <%= f.input :password,
                            required: true,
                            hint: ("#{@minimum_password_length} characters minimum" if @minimum_password_length),
                            input_html: { autocomplete: "new-password", class: "form-control" } %>
              </div>

              <div class="mb-3">
                <%= f.input :password_confirmation,
                            required: true,
                            input_html: { autocomplete: "new-password", class: "form-control" } %>
              </div>

              <div class="d-grid mt-4">
                <%= f.button :submit, "Sign up", class: "btn btn-primary btn-lg" %>
              </div>
            <% end %>

            <%= render "devise/shared/links" %>
          </div>
        </div>
      </div>
    </div>
  ERB

  create_file "app/views/devise/registrations/edit.html.erb", <<~'ERB', force: true
    <div class="row justify-content-center">
      <div class="col-12 col-sm-10 col-md-8 col-lg-6">
        <div class="card shadow-sm border-0 rounded-3">
          <div class="card-body p-4 p-md-5">
            <div class="mb-4">
              <h2 class="fw-bold h3 mb-1">Edit Account</h2>
              <p class="text-secondary small">Update your profile settings and password</p>
            </div>

            <%= simple_form_for(resource, as: resource_name, url: registration_path(resource_name), html: { method: :put }) do |f| %>
              <%= f.error_notification %>

              <div class="mb-3">
                <%= f.input :email, required: true, autofocus: true, input_html: { class: "form-control" } %>

                <% if devise_mapping.confirmable? && resource.pending_reconfirmation? %>
                  <div class="alert alert-info py-2 mt-2 mb-0 small">
                    Currently waiting confirmation for: <strong><%= resource.unconfirmed_email %></strong>
                  </div>
                <% end %>
              </div>

              <div class="mb-3">
                <%= f.input :password,
                            hint: "leave it blank if you don't want to change it",
                            required: false,
                            input_html: { autocomplete: "new-password", class: "form-control" } %>
              </div>

              <div class="mb-3">
                <%= f.input :password_confirmation,
                            required: false,
                            input_html: { autocomplete: "new-password", class: "form-control" } %>
              </div>

              <div class="mb-3">
                <%= f.input :current_password,
                            hint: "we need your current password to confirm your changes",
                            required: true,
                            input_html: { autocomplete: "current-password", class: "form-control" } %>
              </div>

              <div class="d-flex justify-content-between align-items-center mt-4">
                <%= link_to "Back", :back, class: "btn btn-outline-secondary" %>
                <%= f.button :submit, "Update Profile", class: "btn btn-primary" %>
              </div>
            <% end %>

            <hr class="my-4">

            <div class="card bg-danger-subtle border-danger-subtle">
              <div class="card-body p-3 text-danger-emphasis d-flex justify-content-between align-items-center">
                <div>
                  <h6 class="fw-bold mb-0">Cancel my account</h6>
                  <small>Permanently delete your account and all associated data.</small>
                </div>
                <%= button_to "Delete Account", registration_path(resource_name), data: { confirm: "Are you sure?", turbo_confirm: "Are you sure?" }, method: :delete, class: "btn btn-sm btn-danger" %>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  ERB

  create_file "app/views/devise/passwords/new.html.erb", <<~'ERB', force: true
    <div class="row justify-content-center">
      <div class="col-12 col-sm-10 col-md-8 col-lg-5">
        <div class="card shadow-sm border-0 rounded-3">
          <div class="card-body p-4 p-md-5">
            <div class="text-center mb-4">
              <h2 class="fw-bold h3 mb-1">Forgot password?</h2>
              <p class="text-secondary small">Enter your email address to reset your password</p>
            </div>

            <%= simple_form_for(resource, as: resource_name, url: password_path(resource_name), html: { method: :post }) do |f| %>
              <%= f.error_notification %>

              <div class="mb-3">
                <%= f.input :email,
                            required: true,
                            autofocus: true,
                            input_html: { autocomplete: "email", class: "form-control" } %>
              </div>

              <div class="d-grid mt-4">
                <%= f.button :submit, "Send reset instructions", class: "btn btn-primary btn-lg" %>
              </div>
            <% end %>

            <%= render "devise/shared/links" %>
          </div>
        </div>
      </div>
    </div>
  ERB

  create_file "app/views/devise/passwords/edit.html.erb", <<~'ERB', force: true
    <div class="row justify-content-center">
      <div class="col-12 col-sm-10 col-md-8 col-lg-5">
        <div class="card shadow-sm border-0 rounded-3">
          <div class="card-body p-4 p-md-5">
            <div class="text-center mb-4">
              <h2 class="fw-bold h3 mb-1">Change password</h2>
              <p class="text-secondary small">Set a new password for your account</p>
            </div>

            <%= simple_form_for(resource, as: resource_name, url: password_path(resource_name), html: { method: :put }) do |f| %>
              <%= f.error_notification %>

              <%= f.input :reset_password_token, as: :hidden %>
              <%= f.full_error :reset_password_token %>

              <div class="mb-3">
                <%= f.input :password,
                            label: "New password",
                            required: true,
                            autofocus: true,
                            hint: ("#{@minimum_password_length} characters minimum" if @minimum_password_length),
                            input_html: { autocomplete: "new-password", class: "form-control" } %>
              </div>

              <div class="mb-3">
                <%= f.input :password_confirmation,
                            label: "Confirm new password",
                            required: true,
                            input_html: { autocomplete: "new-password", class: "form-control" } %>
              </div>

              <div class="d-grid mt-4">
                <%= f.button :submit, "Change my password", class: "btn btn-primary btn-lg" %>
              </div>
            <% end %>

            <%= render "devise/shared/links" %>
          </div>
        </div>
      </div>
    </div>
  ERB

  create_file "app/views/devise/confirmations/new.html.erb", <<~'ERB', force: true
    <div class="row justify-content-center">
      <div class="col-12 col-sm-10 col-md-8 col-lg-5">
        <div class="card shadow-sm border-0 rounded-3">
          <div class="card-body p-4 p-md-5">
            <div class="text-center mb-4">
              <h2 class="fw-bold h3 mb-1">Resend confirmation</h2>
              <p class="text-secondary small">Request a new account confirmation email</p>
            </div>

            <%= simple_form_for(resource, as: resource_name, url: confirmation_path(resource_name), html: { method: :post }) do |f| %>
              <%= f.error_notification %>
              <%= f.full_error :confirmation_token %>

              <div class="mb-3">
                <%= f.input :email,
                            required: true,
                            autofocus: true,
                            value: (resource.pending_reconfirmation? ? resource.unconfirmed_email : resource.email),
                            input_html: { autocomplete: "email", class: "form-control" } %>
              </div>

              <div class="d-grid mt-4">
                <%= f.button :submit, "Resend instructions", class: "btn btn-primary btn-lg" %>
              </div>
            <% end %>

            <%= render "devise/shared/links" %>
          </div>
        </div>
      </div>
    </div>
  ERB

  create_file "app/views/devise/unlocks/new.html.erb", <<~'ERB', force: true
    <div class="row justify-content-center">
      <div class="col-12 col-sm-10 col-md-8 col-lg-5">
        <div class="card shadow-sm border-0 rounded-3">
          <div class="card-body p-4 p-md-5">
            <div class="text-center mb-4">
              <h2 class="fw-bold h3 mb-1">Resend unlock</h2>
              <p class="text-secondary small">Request instructions to unlock your account</p>
            </div>

            <%= simple_form_for(resource, as: resource_name, url: unlock_path(resource_name), html: { method: :post }) do |f| %>
              <%= f.error_notification %>
              <%= f.full_error :unlock_token %>

              <div class="mb-3">
                <%= f.input :email,
                            required: true,
                            autofocus: true,
                            input_html: { autocomplete: "email", class: "form-control" } %>
              </div>

              <div class="d-grid mt-4">
                <%= f.button :submit, "Resend unlock instructions", class: "btn btn-primary btn-lg" %>
              </div>
            <% end %>

            <%= render "devise/shared/links" %>
          </div>
        </div>
      </div>
    </div>
  ERB

  create_file "app/views/devise/shared/_links.html.erb", <<~'ERB', force: true
    <div class="mt-4 pt-3 border-top text-center text-secondary small">
      <%- if controller_name != 'sessions' %>
        <div class="mb-1">Already have an account? <%= link_to "Log in", new_session_path(resource_name), data: { turbo: false }, class: "text-decoration-none fw-semibold" %></div>
      <% end %>

      <%- if devise_mapping.registerable? && controller_name != 'registrations' %>
        <div class="mb-1">Don't have an account? <%= link_to "Sign up", new_registration_path(resource_name), data: { turbo: false }, class: "text-decoration-none fw-semibold" %></div>
      <% end %>

      <%- if devise_mapping.recoverable? && controller_name != 'passwords' && controller_name != 'registrations' %>
        <div class="mb-1"><%= link_to "Forgot your password?", new_password_path(resource_name), class: "text-decoration-none" %></div>
      <% end %>

      <%- if devise_mapping.confirmable? && controller_name != 'confirmations' %>
        <div class="mb-1"><%= link_to "Didn't receive confirmation instructions?", new_confirmation_path(resource_name), class: "text-decoration-none" %></div>
      <% end %>

      <%- if devise_mapping.lockable? && resource_class.unlock_strategy_enabled?(:email) && controller_name != 'unlocks' %>
        <div class="mb-1"><%= link_to "Didn't receive unlock instructions?", new_unlock_path(resource_name), class: "text-decoration-none" %></div>
      <% end %>
    </div>

    <%- if devise_mapping.omniauthable? %>
      <div class="text-center mt-4">
        <div class="position-relative mb-3">
          <hr class="text-secondary opacity-25">
          <span class="position-absolute top-50 start-50 translate-middle bg-body px-3 text-secondary small">
            <%- if controller_name == 'sessions' %>
              or log in with
            <%- else %>
              or create account with
            <% end %>
          </span>
        </div>

        <div class="d-flex gap-2">
          <%- resource_class.omniauth_providers.each do |provider| %>
            <%= button_to omniauth_authorize_path(resource_name, provider), data: { turbo: false }, class: "btn btn-outline-secondary flex-grow-1 d-flex align-items-center justify-content-center gap-2 py-2", form_class: "flex-grow-1" do %>
              <i class="bi bi-<%= omniauth_icon(provider) %> fs-5"></i>
              <span class="text-capitalize small"><%= provider.to_s.split('_').first %></span>
            <% end %>
          <% end %>
        </div>
      </div>
    <% end %>
  ERB

  create_file "app/views/devise/shared/_error_messages.html.erb", <<~'ERB', force: true
    <% if resource.errors.any? %>
      <div id="error_explanation" class="alert alert-danger" data-turbo-cache="false">
        <h5 class="alert-heading h6 fw-bold">
          <%= I18n.t("errors.messages.not_saved",
                     count: resource.errors.count,
                     resource: resource.class.model_name.human.downcase)
           %>
        </h5>
        <ul class="mb-0 ps-3 small">
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
