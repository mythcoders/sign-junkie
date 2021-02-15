# frozen_string_literal: true

module SeatService
  # Parses form params from creating/updating a seat into a Hash
  class GuestOwnerParser
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
      else
        non_child_owner_attributes
      end
    end

    private

    def child_owner_attributes
      {
        type: @params.guest_type,
        first_name: @params.child_first_name,
        last_name: @params.child_last_name,
        parent: person_attributes
      }
    end

    def non_child_owner_attributes
      person_attributes.merge(type: @params.guest_type)
    end

    def person_attributes
      {
        first_name: @params.first_name,
        last_name: @params.last_name,
        email: @params.email
      }
    end
  end
end