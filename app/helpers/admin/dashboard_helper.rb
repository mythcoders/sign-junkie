# frozen_string_literal: true

module Admin
  module DashboardHelper
    def welcome_message
      greeting = case Time.zone.now.hour
                 when 4..11 then 'Good morning'
                 when 12..17 then 'Good afternoon'
                 when 18..23 then 'Good evening'
                 else
                   'Hello there'
                 end

      if current_user.full_name.blank?
        "#{greeting}!"
      else
        "#{greeting}, #{current_user.full_name}!"
      end
    end
  end
end
