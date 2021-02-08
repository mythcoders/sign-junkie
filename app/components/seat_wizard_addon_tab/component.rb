# frozen_string_literal: true

module SeatWizardAddonTab
  class Component < ViewComponent::Base
    def initialize(project, selected_id = nil)
      @project = project
      @selected_id = selected_id
    end
  end
end
