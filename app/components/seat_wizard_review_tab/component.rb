# frozen_string_literal: true

module SeatWizardReviewTab
  class Component < ViewComponent::Base
    include WorkshopsHelper

    def initialize(seat)
      @seat = seat
    end

    delegate :workshop, to: :@seat

    def require_affirmations
      !@seat.persisted? && !@seat.selection_made?
    end
  end
end
