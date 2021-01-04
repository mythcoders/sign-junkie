# frozen_string_literal: true

module SeatWizardReviewTab
  class Component < ViewComponent::Base
    include WorkshopsHelper

    def initialize(workshop)
      @workshop = workshop
    end
  end
end
