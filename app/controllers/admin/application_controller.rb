module Admin
  class ApplicationController < ::ApplicationController
    before_action :authenticate_user!
  end
end