# frozen_string_literal: true

module SeatWizardGuestTab
  class Component < ViewComponent::Base
    def initialize(allow_editing:, existing_seat_id:, allow_child:, reservation_mode:, seat:)
      @allow_editing = allow_editing
      @existing_seat_id = existing_seat_id
      @family_friendly_enabled = allow_child
      @reservation_mode = reservation_mode
      @seat = seat
    end

    def already_attending?
      @existing_seat_id != 0
    end

    def guest_type_radio_attributes
      {
        name: 'cart[guest_type]',
        type: "radio",
        'data-seat-wizard-guest-tab--component-target': 'guestType',
        'data-action': "seat-wizard-guest-tab--component#toggleGuestType"
      }
    end
  end
end
