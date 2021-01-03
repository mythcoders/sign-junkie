# frozen_string_literal: true

module SeatService
  class StencilParser
    def initialize(project_id)
      @project = Project.find project_id
    end

    def self.parse(project_id, input)
      new(project_id).parse(input)
    end

    def parse(input)
      input.split('::').map do |item|
        id, personalization = item.split('|')
        return plain_stencil_option if id == 'PLAIN_STENCIL'

        stencil = @project.stencils.find id
        {
          id: stencil.id,
          name: stencil.name,
          personalization: personalization == 'null' ? nil : personalization
        }
      end
    end

    private

    def plain_stencil_option
      {
        id: 0,
        name: I18n.translate('seat.plain_stencil'),
        personalization: nil
      }
    end
  end
end
