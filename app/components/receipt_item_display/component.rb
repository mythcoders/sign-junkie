# frozen_string_literal: true

module ReceiptItemDisplay
  class Component < ItemDescriptionDisplay::Component
    def initialize(item)
      super(item: item,
            icons: false,
            status: false,
            title: true,
            linkable_title: true,
            admin: false)
    end
  end
end
