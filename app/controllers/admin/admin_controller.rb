# frozen_string_literal: true

module Admin
  class AdminController < ::ApplicationController
    before_action :authenticate_user!
    before_action :authorize_user!
    layout 'admin'

    def authorize_user!
      redirect_to new_user_session_path unless current_user.can_cp?
    end
  end
end
