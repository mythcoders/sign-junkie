# frozen_string_literal: true

module SeatWizardAddonTab
  class Component < ViewComponent::Base
    def initialize(project, selected_id = nil)
      @project = project
    end
  end
end
