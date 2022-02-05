# frozen_string_literal: true

module WorkshopSearchResults
  class Component < ViewComponent::Base
    def initialize(workshops)
      @workshops = workshops
    end
  end
end
