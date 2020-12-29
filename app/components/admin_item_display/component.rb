# frozen_string_literal: true

module AdminItemDisplay
  class Component < ItemDescriptionDisplay::Component
    def initialize(item)
      super(item: item,
            icons: true,
            status: true,
            title: true,
            linkable_title: true,
            admin: true)
    end
  end
end
