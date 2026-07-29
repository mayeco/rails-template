def add_mailers
  puts "\n==> 8. Creating Mailer Views and Layouts..."

  create_file "app/views/layouts/mailer.html.erb", <<~'ERB', force: true
    <!DOCTYPE html>
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <style>
          body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; background-color: #f8fafc; color: #1e293b; margin: 0; padding: 20px; }
          .container { max-width: 580px; margin: 0 auto; background: #ffffff; border-radius: 12px; padding: 32px; border: 1px solid #e2e8f0; }
          .footer { margin-top: 24px; font-size: 12px; color: #64748b; text-align: center; }
          a { color: #4f46e5; text-decoration: none; font-weight: 500; }
        </style>
      </head>

      <body>
        <div class="container">
          <%= yield %>
        </div>
        <div class="footer">
          <p>&copy; <%= Time.current.year %> <%= Rails.application.class.module_parent_name.titleize %>. All rights reserved.</p>
        </div>
      </body>
    </html>
  ERB

  create_file "app/views/devise/mailer/confirmation_instructions.html.erb", <<~'ERB', force: true
    <p><%= t("devise.mailer.confirmation_instructions.welcome", email: @email) %></p>
    <p><%= t("devise.mailer.confirmation_instructions.confirm_account_text") %></p>
    <p><%= link_to t("devise.mailer.confirmation_instructions.confirm_account_link"), confirmation_url(@resource, confirmation_token: @token) %></p>
  ERB

  create_file "app/views/devise/mailer/email_changed.html.erb", <<~'ERB', force: true
    <p><%= t("devise.mailer.email_changed.hello", email: @email) %></p>

    <% if @resource.try(:unconfirmed_email?) %>
      <p><%= t("devise.mailer.email_changed.changing_email", email: @resource.unconfirmed_email) %></p>
    <% else %>
      <p><%= t("devise.mailer.email_changed.changed_email", email: @resource.email) %></p>
    <% end %>
  ERB

  create_file "app/views/devise/mailer/password_change.html.erb", <<~'ERB', force: true
    <p><%= t("devise.mailer.password_change.hello", email: @resource.email) %></p>
    <p><%= t("devise.mailer.password_change.changed_password") %></p>
  ERB

  create_file "app/views/devise/mailer/reset_password_instructions.html.erb", <<~'ERB', force: true
    <p><%= t("devise.mailer.reset_password_instructions.hello", email: @resource.email) %></p>
    <p><%= t("devise.mailer.reset_password_instructions.request_text") %></p>
    <p><%= link_to t("devise.mailer.reset_password_instructions.change_password_link"), edit_password_url(@resource, reset_password_token: @token) %></p>
    <p><%= t("devise.mailer.reset_password_instructions.ignore_text") %></p>
    <p><%= t("devise.mailer.reset_password_instructions.notice_text") %></p>
  ERB

  create_file "app/views/devise/mailer/unlock_instructions.html.erb", <<~'ERB', force: true
    <p><%= t("devise.mailer.unlock_instructions.hello", email: @resource.email) %></p>
    <p><%= t("devise.mailer.unlock_instructions.locked_text") %></p>
    <p><%= t("devise.mailer.unlock_instructions.unlock_text") %></p>
    <p><%= link_to t("devise.mailer.unlock_instructions.unlock_link"), unlock_url(@resource, unlock_token: @token) %></p>
  ERB
end
