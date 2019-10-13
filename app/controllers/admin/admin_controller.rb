# frozen_string_literal: true

module Admin
  class AdminController < ::ApplicationController
    before_action :authenticate_user!
    before_action :authorize_user!
    before_action :set_theme
    layout 'admin'

    def authorize_user!
      redirect_to new_user_session_path unless current_user.astronaut?
    end

    def set_theme
      @ui_theme = case request.cookies['apollo_ui_theme']
                  when 'dark', 'light'
                    request.cookies['apollo_ui_theme']
                  else
                    'light'
                  end
    end
  end
end
