class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :store_user_location!, if: :storable_location?
  before_action :configure_permitted_parameters, if: :devise_controller?

  layout :layout_by_resource

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def append_info_to_payload(payload)
    super
    payload[:request_id] = request.uuid
    payload[:user_id] = current_user.id if current_user
    payload[:host] = request.host
  end

  private

  def configure_permitted_parameters
    additional_fields = %i[first_name last_name].freeze
    devise_parameter_sanitizer.permit(:sign_up, keys: additional_fields)
    devise_parameter_sanitizer.permit(:account_update, keys: additional_fields)

    return unless user_signed_in? && current_user.can_cp?

    devise_parameter_sanitizer.permit(:account_update, keys: [:role])
  end

  def convert_datetime(value)
    return nil if value.blank?

    Time.zone.strptime(value, t('time.formats.default'))
  end

  def record_not_found
    render file: 'public/404.html', status: :not_found
  end

  def unauthorized
    render file: 'public/401.html', status: :unauthorized
  end

  def layout_by_resource
    'devise' if devise_controller?
  end

  def after_sign_out_path_for(user)
    stored_location_for(user) || super
  end

  def after_sign_in_path_for(user)
    user.can_cp? ? admin_path : home_path
  end

  # Its important that the location is NOT stored if:
  # - The request method is not GET (non idempotent)
  # - The request is handled by a Devise controller such as
  #   Devise::SessionsController as that could cause an infinite redirect loop
  # - The request is an Ajax request as this can lead to very unexpected behavior
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end

  def set_cart_total
    @cart_total = Cart.for(current_user).count
  end
end
