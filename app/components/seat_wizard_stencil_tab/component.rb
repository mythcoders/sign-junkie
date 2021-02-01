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
      @stencils_as_js_object ||= stencils_as_hash.to_json
    end

    def personilized_stencil_text(id)
      stencils_as_hash[id] || nil
    end

    private

    def stencils_as_hash
      @stencils_as_hash ||= if @stencils
                              hash = {}
                              @stencils.each do |s|
                                hash[s['id']] = s['personalization']
                              end
                              hash
                            else
                              {}
                            end
    end
  end
end
