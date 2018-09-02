class ApplicationController < ActionController::Base

  before_action :store_user_location!, if: :storable_location?
  protect_from_forgery with: :exception
  layout :layout_by_resource

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def layout_by_resource
    if devise_controller?
      'devise'
    elsif request.controller_class.superclass == Admin::ApplicationController
      'admin'
    else
      'application'
    end
  end
  
  def append_info_to_payload(payload)
    super
    payload[:request_id] = request.uuid
    payload[:user_id] = current_user.id if current_user
    payload[:host] = request.host
  end

  private

  def record_not_found
    render file: 'public/404.html', status: :not_found
  end

  def unauthorized
    render file: 'public/401.html', status: :unauthorized
  end

  def after_sign_out_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || super
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
    @cart_total = CartItem.for(current_user).count
  end

end
