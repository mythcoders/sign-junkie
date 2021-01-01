# frozen_string_literal: true

class FrontendStencilParser
  def initialize(project_id)
    @project = Project.find project_id
  end

  def parse(input)
    input.split('::').map do |item|
      id, personalization = item.split('|')
      return no_stencil if id == '0'

      stencil = @project.stencils.where(id: id).first
      {
        id: stencil.id,
        name: stencil.name,
        personalization: personalization == 'null' ? nil : personalization
      }
    end
  end

  private

  def no_stencil
    {
      id: 0,
      name: I18n.translate('seat.no_stencil'),
      personalization: nil
    }
  end
end
