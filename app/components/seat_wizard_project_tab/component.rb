# frozen_string_literal: true

module SeatWizardProjectTab
  class Component < ViewComponent::Base
    def initialize(projects, selected_id = nil)
      @projects = projects
      @selected_id = selected_id
    end

    def data_attributes
      {
        'data-controller': "seat-wizard-project",
        'data-seat-wizard-project-project-id-value': @selected_id,
        'data-seat-wizard-project-has-addons-value': addons_value,
        'data-seat-wizard-project-active-class': "bg-selected",
        'data-seat-wizard-project-disabled-class': "disabled"
      }
    end

    def selected_project
      @selected_project ||= @select_id ? Project.find(@select_id) : nil
    end

    private

    def addons_value
      @selected_project.present? ? @selected_project.addons.active.any? : ""
    end
  end
end
