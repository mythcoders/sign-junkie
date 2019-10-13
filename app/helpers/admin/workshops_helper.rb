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
  end
end
