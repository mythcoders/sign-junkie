# frozen_string_literal: true

module ItemDescriptionDisplay
  class Component < ViewComponent::Base
    include IconHelper

    def initialize(item:, icons:, status:, title:, linkable_title:, admin:)
      @item = item
      @show_icons = icons
      @show_status = status
      @show_title = title
      @linkable_title = linkable_title
      @admin = admin
    end
  end
end
