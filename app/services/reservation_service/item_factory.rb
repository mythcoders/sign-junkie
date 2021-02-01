# frozen_string_literal: true

module ReservationService
  # builds an ItemDescription of type Seat
  class ItemFactory
    def initialize(workshop, params)
      @workshop = workshop
      @params = Hashie::Mash.new(params)
    end

    def self.build(workshop, params)
      new(workshop, params).perform
    end

    def perform
      ItemDescription.new(item_type: :reservation,
                          identifier: SecureRandom.uuid,
                          workshop_name: @workshop.name,
                          workshop_id: @workshop.id,
                          payment_plan: @params.payment_plan,
                          nontaxable_amount: @workshop.reservation_price,
                          taxable_amount: 0.00)
    end
  end
end
