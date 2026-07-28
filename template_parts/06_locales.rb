def add_locales
  puts "\n==> 6. Creating Locales and Translations..."

  create_file "config/locales/es.yml", <<~'YAML', force: true
    es:
      layouts:
        application:
          log_out: "Cerrar sesión"
      page:
        index:
          welcome_back: "Bienvenido de nuevo, %{email}!"
          find_me_in: "Encuentra esta vista en %{path}"
      devise:
        sessions:
          new:
            welcome_back: "Bienvenido de nuevo"
            please_log_in: "Por favor inicia sesión en tu cuenta"
            log_in: "Iniciar sesión"
        registrations:
          new:
            create_account: "Crear una cuenta"
            sign_up_to_get_started: "Regístrate para comenzar"
            sign_up: "Registrarse"
          edit:
            edit_account: "Editar Cuenta"
            update_profile_settings: "Actualiza la configuración de tu perfil y contraseña"
            currently_waiting_confirmation_for: "Esperando confirmación para: %{email}"
            back: "Volver"
            update_profile: "Actualizar Perfil"
            cancel_account: "Cancelar mi cuenta"
            permanently_delete_account: "Eliminar permanentemente tu cuenta y todos los datos."
            delete_account: "Eliminar Cuenta"
        passwords:
          new:
            forgot_password: "¿Olvidaste tu contraseña?"
            enter_email_to_reset: "Ingresa tu correo electrónico para restablecer tu contraseña"
            send_reset_instructions: "Enviar instrucciones de restablecimiento"
          edit:
            change_password: "Cambiar contraseña"
            set_new_password: "Establece una nueva contraseña para tu cuenta"
            change_my_password: "Cambiar mi contraseña"
        confirmations:
          new:
            resend_confirmation: "Reenviar confirmación"
            request_new_confirmation_email: "Solicitar un nuevo correo de confirmación de cuenta"
            resend_instructions: "Reenviar instrucciones"
        unlocks:
          new:
            resend_unlock: "Reenviar desbloqueo"
            request_unlock_instructions: "Solicitar instrucciones para desbloquear tu cuenta"
            resend_unlock_instructions: "Reenviar instrucciones de desbloqueo"
        shared:
          links:
            already_have_account: "¿Ya tienes una cuenta?"
            log_in: "Iniciar sesión"
            dont_have_account: "¿No tienes una cuenta?"
            sign_up: "Registrarse"
            forgot_your_password: "¿Olvidaste tu contraseña?"
            didnt_receive_confirmation_instructions: "¿No recibiste las instrucciones de confirmación?"
            didnt_receive_unlock_instructions: "¿No recibiste las instrucciones de desbloqueo?"
            or_log_in_with: "o inicia sesión con"
            or_create_account_with: "o crea tu cuenta con"
  YAML

  create_file "config/locales/en.yml", <<~'YAML', force: true
    en:
      layouts:
        application:
          log_out: "Log out"
      page:
        index:
          welcome_back: "Welcome back, %{email}!"
          find_me_in: "Find this view in %{path}"
      devise:
        sessions:
          new:
            welcome_back: "Welcome back"
            please_log_in: "Please log in to your account"
            log_in: "Log in"
        registrations:
          new:
            create_account: "Create an account"
            sign_up_to_get_started: "Sign up to get started"
            sign_up: "Sign up"
          edit:
            edit_account: "Edit Account"
            update_profile_settings: "Update your profile settings and password"
            currently_waiting_confirmation_for: "Currently waiting confirmation for: %{email}"
            back: "Back"
            update_profile: "Update Profile"
            cancel_account: "Cancel my account"
            permanently_delete_account: "Permanently delete your account and all data."
            delete_account: "Delete Account"
        passwords:
          new:
            forgot_password: "Forgot password?"
            enter_email_to_reset: "Enter your email address to reset your password"
            send_reset_instructions: "Send reset instructions"
          edit:
            change_password: "Change password"
            set_new_password: "Set a new password for your account"
            change_my_password: "Change my password"
        confirmations:
          new:
            resend_confirmation: "Resend confirmation"
            request_new_confirmation_email: "Request a new account confirmation email"
            resend_instructions: "Resend instructions"
        unlocks:
          new:
            resend_unlock: "Resend unlock"
            request_unlock_instructions: "Request instructions to unlock your account"
            resend_unlock_instructions: "Resend unlock instructions"
        shared:
          links:
            already_have_account: "Already have an account?"
            log_in: "Log in"
            dont_have_account: "Don't have an account?"
            sign_up: "Sign up"
            forgot_your_password: "Forgot your password?"
            didnt_receive_confirmation_instructions: "Didn't receive confirmation instructions?"
            didnt_receive_unlock_instructions: "Didn't receive unlock instructions?"
            or_log_in_with: "or log in with"
            or_create_account_with: "or create account with"
  YAML
end
