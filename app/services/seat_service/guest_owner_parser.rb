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
      binding.pry

      if existing_customer.present?
        {
          first_name: existing_customer.first_name,
          last_name: existing_customer.last_name,
          email: existing_customer.email
        }
      else
        {
          first_name: @params.first_name,
          last_name: @params.last_name,
          email: @params.email
        }
      end
    end

    def existing_customer
      @existing_customer ||= User.where('email ILIKE ?', @params.email).first
    end
  end
end
