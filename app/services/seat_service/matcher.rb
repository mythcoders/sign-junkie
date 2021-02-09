# frozen_string_literal: true

module SeatService
  # Matches an already exisitng ItemDescritpion to
  class Matcher
    def initialize(seat, item_description)
      @seat = seat
      @new_item = item_description
    end

    def self.match(seat, item_description)
      new(seat, item_description).match
    end

    def match
      first_name_matches && last_name_matches
    end

    private

    def first_name_matches
      owner.first_name.downcase == @new_item.owner.first_name.downcase
    end

    def last_name_matches
      owner.last_name.downcase == @new_item.owner.last_name.downcase
    end

    def email_matches
      owner.email.downcase == @new_item.owner.email.downcase
    end

    def owner
      @owner ||= case @seat.guest_type
                 when 'other', 'child'
                   @seat.owner
                 else
                   @seat.customer
                 end
    end
  end
end
