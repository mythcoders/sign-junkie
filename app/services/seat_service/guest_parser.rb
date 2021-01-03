# frozen_string_literal: true

module SeatService
  class GuestParser
    def initialize(params)
      @params = params
    end

    def self.parse(params)
      new(params).parse
    end

    def parse
      case @params.guest_type
      when 'child'
        child_owner_attributes
      when 'adult', 'other'
        adult_owner_attributes
      end
    end

    private

    def child_owner_attributes
      {
        type: 'child',
        first_name: @params.child_first_name,
        last_name: @params.child_last_name,
        parent: {
          first_name: @params.first_name,
          last_name: @params.last_name,
          email: @params.email
        }
      }
    end

    def adult_owner_attributes
      {
        type: 'adult',
        first_name: @params.first_name,
        last_name: @params.last_name,
        email: @params.email
      }
    end
  end
end
