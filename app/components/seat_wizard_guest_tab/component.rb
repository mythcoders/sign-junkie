# frozen_string_literal: true

module SeatWizardGuestTab
  class Component < ViewComponent::Base
    def initialize(self_enabled, family_friendly, reservation_mode = false)
      @self_enabled = self_enabled
      @family_friendly_enabled = family_friendly
      @reservation_mode = reservation_mode
    end
  end
end
