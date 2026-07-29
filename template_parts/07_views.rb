def add_views
  puts "\n==> 7. Creating Views and Layouts..."

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
      <%= stylesheet_link_tag "application", "data-turbo-track": Rails.env.production? ? "reload" : "" %>

      <%= debugbar_head if defined? Debugbar %>
    </head>

    <body class="bg-slate-50 min-h-screen flex flex-col font-sans antialiased text-slate-800">
      <main class="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 my-auto py-8">
        <%= render_flash_messages if respond_to?(:render_flash_messages) %>
        <%= yield %>

        <% if user_signed_in? %>
          <div class="text-center mt-6">
            <%= button_to destroy_user_session_path, method: :delete, data: { turbo: false }, class: "inline-flex items-center gap-2 px-3 py-1.5 text-sm font-medium text-red-600 border border-red-200 rounded-md hover:bg-red-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 transition" do %>
              <i class="bi bi-box-arrow-right"></i> <%= t("layouts.application.log_out") %>
            <% end %>
          </div>
        <% end %>
      </main>
      <%= debugbar_body cable: {url: "ws://localhost:3000"} if defined? Debugbar %>
    </body>
    </html>
  ERB

  create_file "app/views/page/index.html.erb", <<~'ERB', force: true
    <div class="max-w-2xl mx-auto text-center py-12">
      <h1 class="text-4xl font-extrabold tracking-tight text-slate-900 sm:text-5xl mb-4">
        <%= Rails.application.class.module_parent_name.titleize %>
      </h1>
      <p class="text-lg text-slate-600 mb-8">
        <%= t(".welcome_back", email: current_user.email) %>
      </p>
      <div class="bg-white shadow-sm border border-slate-200 rounded-xl p-6">
        <p class="text-sm text-slate-500">
          <%= t(".find_me_in", path: "app/views/page/index.html.erb") %>
        </p>
      </div>
    </div>
  ERB

  # Devise Views
  create_file "app/views/devise/sessions/new.html.erb", <<~'ERB', force: true
    <div class="max-w-md mx-auto">
      <div class="bg-white shadow-md border border-slate-200 rounded-2xl p-6 sm:p-8">
        <div class="text-center mb-6">
          <h2 class="text-2xl font-bold text-slate-900"><%= t(".welcome_back") %></h2>
          <p class="text-sm text-slate-500 mt-1"><%= t(".please_log_in") %></p>
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
            <%= f.button :submit, t(".log_in"), class: "w-full py-2.5 px-4 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2" %>
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
          <h2 class="text-2xl font-bold text-slate-900"><%= t(".create_account") %></h2>
          <p class="text-sm text-slate-500 mt-1"><%= t(".sign_up_to_get_started") %></p>
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
                        hint: (t(".minimum_password_length", count: @minimum_password_length) if @minimum_password_length),
                        input_html: { autocomplete: "new-password" } %>

            <%= f.input :password_confirmation,
                        required: true,
                        input_html: { autocomplete: "new-password" } %>
          </div>

          <div class="mt-6">
            <%= f.button :submit, t(".sign_up"), class: "w-full py-2.5 px-4 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2" %>
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
          <h2 class="text-2xl font-bold text-slate-900"><%= t(".edit_account") %></h2>
          <p class="text-sm text-slate-500 mt-1"><%= t(".update_profile_settings") %></p>
        </div>

        <%= simple_form_for(resource, as: resource_name, url: registration_path(resource_name), html: { method: :put }) do |f| %>
          <%= f.error_notification %>

          <div class="space-y-4">
            <%= f.input :email, required: true, autofocus: true %>

            <% if devise_mapping.confirmable? && resource.pending_reconfirmation? %>
              <div class="p-3 bg-blue-50 border border-blue-200 text-blue-800 rounded-lg text-xs">
                <%= t(".currently_waiting_confirmation_for", email: resource.unconfirmed_email) %>
              </div>
            <% end %>

            <%= f.input :password,
                        hint: t(".leave_blank_if_unchanged"),
                        required: false,
                        input_html: { autocomplete: "new-password" } %>

            <%= f.input :password_confirmation,
                        required: false,
                        input_html: { autocomplete: "new-password" } %>

            <%= f.input :current_password,
                        hint: t(".need_current_password"),
                        required: true,
                        input_html: { autocomplete: "current-password" } %>
          </div>

          <div class="flex items-center justify-between mt-6">
            <%= link_to t(".back"), :back, class: "px-4 py-2 border border-slate-300 text-slate-700 font-medium rounded-lg text-sm hover:bg-slate-50 transition" %>
            <%= f.button :submit, t(".update_profile"), class: "py-2.5 px-5 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2" %>
          </div>
        <% end %>

        <div class="mt-8 pt-6 border-t border-slate-200">
          <div class="bg-red-50 border border-red-200 rounded-xl p-4 flex items-center justify-between">
            <div>
              <h3 class="text-sm font-semibold text-red-900"><%= t(".cancel_account") %></h3>
              <p class="text-xs text-red-600 mt-0.5"><%= t(".permanently_delete_account") %></p>
            </div>
            <%= button_to t(".delete_account"), registration_path(resource_name), data: { confirm: t(".are_you_sure"), turbo_confirm: t(".are_you_sure") }, method: :delete, class: "px-3 py-1.5 bg-red-600 hover:bg-red-700 text-white text-xs font-semibold rounded-md shadow-sm transition" %>
          </div>
        </div>
      </div>
    </div>
  ERB

  create_file "app/views/devise/passwords/new.html.erb", <<~'ERB', force: true
    <div class="max-w-md mx-auto">
      <div class="bg-white shadow-md border border-slate-200 rounded-2xl p-6 sm:p-8">
        <div class="text-center mb-6">
          <h2 class="text-2xl font-bold text-slate-900"><%= t(".forgot_password") %></h2>
          <p class="text-sm text-slate-500 mt-1"><%= t(".enter_email_to_reset") %></p>
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
            <%= f.button :submit, t(".send_reset_instructions"), class: "w-full py-2.5 px-4 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2" %>
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
          <h2 class="text-2xl font-bold text-slate-900"><%= t(".change_password") %></h2>
          <p class="text-sm text-slate-500 mt-1"><%= t(".set_new_password") %></p>
        </div>

        <%= simple_form_for(resource, as: resource_name, url: password_path(resource_name), html: { method: :put }) do |f| %>
          <%= f.error_notification %>

          <%= f.input :reset_password_token, as: :hidden %>
          <%= f.full_error :reset_password_token %>

          <div class="space-y-4">
            <%= f.input :password,
                        label: t(".new_password"),
                        required: true,
                        autofocus: true,
                        hint: (t("devise.registrations.new.minimum_password_length", count: @minimum_password_length) if @minimum_password_length),
                        input_html: { autocomplete: "new-password" } %>

            <%= f.input :password_confirmation,
                        label: t(".confirm_new_password"),
                        required: true,
                        input_html: { autocomplete: "new-password" } %>
          </div>

          <div class="mt-6">
            <%= f.button :submit, t(".change_my_password"), class: "w-full py-2.5 px-4 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2" %>
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
          <h2 class="text-2xl font-bold text-slate-900"><%= t(".resend_confirmation") %></h2>
          <p class="text-sm text-slate-500 mt-1"><%= t(".request_new_confirmation_email") %></p>
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
            <%= f.button :submit, t(".resend_instructions"), class: "w-full py-2.5 px-4 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2" %>
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
          <h2 class="text-2xl font-bold text-slate-900"><%= t(".resend_unlock") %></h2>
          <p class="text-sm text-slate-500 mt-1"><%= t(".request_unlock_instructions") %></p>
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
            <%= f.button :submit, t(".resend_unlock_instructions"), class: "w-full py-2.5 px-4 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg shadow-sm transition focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2" %>
          </div>
        <% end %>

        <%= render "devise/shared/links" %>
      </div>
    </div>
  ERB

  create_file "app/views/devise/shared/_links.html.erb", <<~'ERB', force: true
    <div class="mt-6 pt-4 border-t border-slate-200 text-center text-xs text-slate-500 space-y-2">
      <%- if controller_name != 'sessions' %>
        <div><%= t(".already_have_account") %> <%= link_to t(".log_in"), new_session_path(resource_name), data: { turbo: false }, class: "font-semibold text-indigo-600 hover:text-indigo-500" %></div>
      <% end %>

      <%- if devise_mapping.registerable? && controller_name != 'registrations' %>
        <div><%= t(".dont_have_account") %> <%= link_to t(".sign_up"), new_registration_path(resource_name), data: { turbo: false }, class: "font-semibold text-indigo-600 hover:text-indigo-500" %></div>
      <% end %>

      <%- if devise_mapping.recoverable? && controller_name != 'passwords' && controller_name != 'registrations' %>
        <div><%= link_to t(".forgot_your_password"), new_password_path(resource_name), class: "hover:underline" %></div>
      <% end %>

      <%- if devise_mapping.confirmable? && controller_name != 'confirmations' %>
        <div><%= link_to t(".didnt_receive_confirmation_instructions"), new_confirmation_path(resource_name), class: "hover:underline" %></div>
      <% end %>

      <%- if devise_mapping.lockable? && resource_class.unlock_strategy_enabled?(:email) && controller_name != 'unlocks' %>
        <div><%= link_to t(".didnt_receive_unlock_instructions"), new_unlock_path(resource_name), class: "hover:underline" %></div>
      <% end %>
    </div>

    <%- if devise_mapping.omniauthable? %>
      <div class="mt-6">
        <div class="relative flex py-2 items-center">
          <div class="flex-grow border-t border-slate-200"></div>
          <span class="flex-shrink mx-3 text-xs text-slate-400 uppercase tracking-wider">
            <%- if controller_name == 'sessions' %>
              <%= t(".or_log_in_with") %>
            <%- else %>
              <%= t(".or_create_account_with") %>
            <% end %>
          </span>
          <div class="flex-grow border-t border-slate-200"></div>
        </div>

        <div class="mt-3 flex gap-2">
          <%- resource_class.omniauth_providers.each do |provider| %>
            <%= button_to omniauth_authorize_path(resource_name, provider), data: { turbo: false }, class: "flex-1 inline-flex justify-center items-center gap-2 py-2 px-3 border border-slate-300 rounded-lg shadow-sm bg-white text-xs font-medium text-slate-700 hover:bg-slate-50 transition focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2", form_class: "flex-1" do %>
              <i class="bi bi-<%= provider.to_s.split('_').first %> text-base"></i>
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
end
