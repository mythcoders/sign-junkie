# frozen_string_literal: true

module Admin
  module DashboardHelper
    def welcome_message
      if current_user.full_name.blank?
        'Welcome!'
      else
        "Welcome, #{current_user.full_name}!"
      end
    end
  end
end
