# frozen_string_literal: true

module WorkshopSearchResults
  class Component < ViewComponent::Base
    def initialize(workshops)
      @workshops = workshops
    end

    def sold_out_text(workshop)
      if workshop.reservations_allowed? && !workshop.multiple_reservations_allowed?
        "BOOKED!"
      else
        "SOLD OUT!"
      end
    end
  end
end
