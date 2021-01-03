# frozen_string_literal: true

module GiftCardService
  # builds an ItemDescription of type Gift Card
  class ItemFactory
    def initialize(params)
      @params = Hashie::Mash.new(params)
    end

    def self.build(params)
      new(params).perform
    end

    def perform
      ItemDescription.new(item_type: :gift_card,
                          identifier: SecureRandom.uuid,
                          nontaxable_amount: @params.amount,
                          taxable_amount: 0.00,
                          owner: {
                            first_name: @params.first_name,
                            last_name: @params.last_name,
                            email: @params.email
                          })
    end
  end
end