# frozen_string_literal: true

module InvoiceItemDisplay
  class Component < ItemDescriptionDisplay::Component
    def initialize(item)
      super(item: item,
            icons: true,
            status: true,
            title: true,
            linkable_title: true,
            admin: false)
    end
  end
end
