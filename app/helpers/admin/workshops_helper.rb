# frozen_string_literal: true

module Admin
  module WorkshopsHelper
    def overriden_boolean_select_options
      [
        ['Default', ''],
        ['Override - No', 'false'],
        ['Override - Yes', 'true']
      ]
    end

    def whodunnit(version)
      if version.whodunnit
        user = User.find version.whodunnit
        user.nil? ? 'Unknown user' : user.full_name
      else
        'Apollo System'
      end
    end

    def versions_activity_icon(event)
      case event
      when 'create'
        'plus'
      when 'update'
        'edit'
      when 'delete'
        'times'
      end
    end
  end
end
