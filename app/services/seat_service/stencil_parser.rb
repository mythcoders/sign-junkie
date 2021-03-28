# frozen_string_literal: true

module SeatService
  class StencilParser
    PLAIN_STENCIL_KEY = 'PLAIN_STENCIL'

    def initialize(project_id)
      @project = Project.find project_id
    end

    def self.parse(project_id, input)
      new(project_id).parse(input)
    end

    # converts the HTML field value to a hash that can be saved in the database
    def parse(input)
      input.split('::').map do |item|
        id, personalization = item.split('|')

        if id == '0' && personalization == PLAIN_STENCIL_KEY
          plain_stencil_option
        else
          stencil = @project.stencils.find id
          {
            id: stencil.id,
            name: stencil.name,
            personalization: personalization == 'null' ? nil : personalization
          }
        end
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
