module Admin
  class AdminController < ::ApplicationController
    before_action :authenticate_user!
    before_action :authorize_user!
    layout 'admin'

    def authorize_user!
      redirect_to home_path unless current_user.can_cp?
    end
  end
end
