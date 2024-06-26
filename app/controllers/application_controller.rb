# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_paper_trail_whodunnit
  before_action :set_user_context
  before_action :store_user_location!, if: :storable_location?
  before_action :set_permitted_parameters, if: :devise_controller?

  layout :layout_by_resource

  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404

  def append_info_to_payload(payload)
    super
    payload[:request_id] = request.uuid
    payload[:user_id] = current_user.id if current_user
    payload[:host] = request.host
  end

  private

  def set_user_context
    return unless current_user

    Appsignal.tag_request(
      id: current_user.id,
      email: current_user.email,
      ip_address: request.ip
    )
  end

  def set_permitted_parameters
    additional_fields = %i[first_name last_name].freeze
    devise_parameter_sanitizer.permit(:sign_up, keys: additional_fields)
    devise_parameter_sanitizer.permit(:account_update, keys: additional_fields)

    return unless user_signed_in? && current_user.astronaut?

    devise_parameter_sanitizer.permit(:account_update, keys: [:role])
  end

  def render_404
    respond_to do |format|
      format.html { render file: "public/404.html", status: 404 }
      format.all { render nothing: true, status: 404 }
    end
  end

  def render_401
    respond_to do |format|
      format.html { render file: "public/401.html", status: 401 }
      format.all { render nothing: true, status: 401 }
    end
  end

  def layout_by_resource
    "devise" if devise_controller?
  end

  def after_sign_out_path_for(user)
    stored_location_for(user) || super
  end

  def after_sign_in_path_for(user)
    stored_location_for(user) || super
  end

  # Its important that the location is NOT stored if:
  # - The request method is not GET (non idempotent)
  # - The request is handled by a Devise controller such as Devise::SessionsController
  #   as that could cause an infinite redirect loop
  # - The request is an Ajax request as this can lead to very unexpected behavior
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end
end
