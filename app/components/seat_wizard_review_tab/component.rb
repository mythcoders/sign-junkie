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

    def affirmations
      @affirmations ||= Affirmation
        .where(active: true, workshop_type_id: @seat.workshop.workshop_type_id)
        .where(for_seats: true)
        .order(:title)
    end
  end
end
