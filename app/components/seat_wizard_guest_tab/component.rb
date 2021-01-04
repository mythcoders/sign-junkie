# frozen_string_literal: true

module SeatWizardGuestTab
  class Component < ViewComponent::Base
    def initialize(allow_editing:, already_attending:, allow_child:, reservation_mode:)
      @allow_editing = allow_editing
      @already_attending = already_attending
      @allow_child = allow_child
      @reservation_mode = reservation_mode
    end
  end
end
