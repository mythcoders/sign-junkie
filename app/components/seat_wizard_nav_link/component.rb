# frozen_string_literal: true

module SeatWizardNavLink
  class Component < ViewComponent::Base
    def initialize(name, disabled:, active:)
      @name = name
      @disabled = disabled
      @active = active
    end

    with_content_areas :body

    def css_class
      css = 'nav-link'
      css += ' disabled' if @disabled
      css += ' active' if @active
      css
    end
  end
end
