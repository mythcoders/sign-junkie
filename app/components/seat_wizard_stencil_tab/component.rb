# frozen_string_literal: true

module SeatWizardStencilTab
  class Component < ViewComponent::Base
    def initialize(project, selected_id = nil)
      @project = project
    end
  end
end
