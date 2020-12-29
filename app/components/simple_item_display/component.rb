# frozen_string_literal: true

module SimpleItemDisplay
  class Component < ItemDescriptionDisplay::Component
    def initialize(item)
      super(item: item,
            icons: true,
            status: true,
            title: true,
            linkable_title: false,
            admin: false)
    end
  end
end
