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
            minimum_password_length: "%{count} caracteres mínimo"
          edit:
            edit_account: "Editar Cuenta"
            update_profile_settings: "Actualiza la configuración de tu perfil y contraseña"
            currently_waiting_confirmation_for: "Esperando confirmación para: %{email}"
            leave_blank_if_unchanged: "déjalo en blanco si no quieres cambiarlo"
            need_current_password: "necesitamos tu contraseña actual para confirmar los cambios"
            are_you_sure: "¿Estás seguro?"
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
            new_password: "Nueva contraseña"
            confirm_new_password: "Confirmar nueva contraseña"
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
        mailer:
          confirmation_instructions:
            welcome: "¡Bienvenido %{email}!"
            confirm_account_text: "Puedes confirmar el correo de tu cuenta a través del siguiente enlace:"
            confirm_account_link: "Confirmar mi cuenta"
          email_changed:
            hello: "¡Hola %{email}!"
            changing_email: "Te contactamos para notificarte que tu correo está siendo cambiado a %{email}."
            changed_email: "Te contactamos para notificarte que tu correo ha sido cambiado a %{email}."
          password_change:
            hello: "¡Hola %{email}!"
            changed_password: "Te contactamos para notificarte que tu contraseña ha sido cambiada."
          reset_password_instructions:
            hello: "¡Hola %{email}!"
            request_text: "Alguien ha solicitado un enlace para cambiar tu contraseña. Puedes hacerlo a través del enlace de abajo."
            change_password_link: "Cambiar mi contraseña"
            ignore_text: "Si no solicitaste esto, por favor ignora este correo."
            notice_text: "Tu contraseña no cambiará hasta que accedas al enlace y crees una nueva."
          unlock_instructions:
            hello: "¡Hola %{email}!"
            locked_text: "Tu cuenta ha sido bloqueada debido a un número excesivo de intentos fallidos de inicio de sesión."
            unlock_text: "Haz clic en el enlace de abajo para desbloquear tu cuenta:"
            unlock_link: "Desbloquear mi cuenta"
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
            minimum_password_length: "%{count} characters minimum"
          edit:
            edit_account: "Edit Account"
            update_profile_settings: "Update your profile settings and password"
            currently_waiting_confirmation_for: "Currently waiting confirmation for: %{email}"
            leave_blank_if_unchanged: "leave blank if you don't want to change it"
            need_current_password: "we need your current password to confirm your changes"
            are_you_sure: "Are you sure?"
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
            new_password: "New password"
            confirm_new_password: "Confirm new password"
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
        mailer:
          confirmation_instructions:
            welcome: "Welcome %{email}!"
            confirm_account_text: "You can confirm your account email through the link below:"
            confirm_account_link: "Confirm my account"
          email_changed:
            hello: "Hello %{email}!"
            changing_email: "We're contacting you to notify you that your email is being changed to %{email}."
            changed_email: "We're contacting you to notify you that your email has been changed to %{email}."
          password_change:
            hello: "Hello %{email}!"
            changed_password: "We're contacting you to notify you that your password has been changed."
          reset_password_instructions:
            hello: "Hello %{email}!"
            request_text: "Someone has requested a link to change your password. You can do this through the link below."
            change_password_link: "Change my password"
            ignore_text: "If you didn't request this, please ignore this email."
            notice_text: "Your password won't change until you access the link above and create a new one."
          unlock_instructions:
            hello: "Hello %{email}!"
            locked_text: "Your account has been locked due to an excessive number of unsuccessful sign in attempts."
            unlock_text: "Click the link below to unlock your account:"
            unlock_link: "Unlock my account"
  YAML
end
