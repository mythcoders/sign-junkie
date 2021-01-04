# frozen_string_literal: true

module SeatWizardProjectTab
  class Component < ViewComponent::Base
    def initialize(projects, selected_id = nil)
      @projects = projects
      @selected_id = selected_id
    end
  end
end
