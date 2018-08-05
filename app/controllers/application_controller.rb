class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  layout :layout_by_resource

  def layout_by_resource
    if devise_controller?
      'devise'
    elsif request.controller_class.superclass == Admin::ApplicationController
      'admin'
    else
      'application'
    end
  end

end
