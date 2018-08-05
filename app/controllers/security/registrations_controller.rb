# frozen_string_literal: true

class Security::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: %i[create]

  private

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys:
        %i[first_name middle_name last_name phone_number])
  end
end
