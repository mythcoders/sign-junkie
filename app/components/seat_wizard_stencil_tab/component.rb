# frozen_string_literal: true

module SeatWizardStencilTab
  class Component < ViewComponent::Base
    def initialize(project, stencils = nil)
      @project = project
      @stencils = stencils
    end

    def selection_made?
      @stencils.present?
    end

    def stencils_as_js_object
      return {}.to_json unless @stencils

      hash = {}
      @stencils.each do |s|
        hash[s['id']] = s['personalization']
      end
      hash.to_json
    end
  end
end
