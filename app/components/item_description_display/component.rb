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

    class << self
      def default(item, linkable_title:)
        new(item: item,
            icons: true,
            status: true,
            title: true,
            linkable_title: linkable_title,
            admin: false)
      end

      def admin(item)
        new(item: item,
            icons: true,
            status: true,
            title: true,
            linkable_title: true,
            admin: true)
      end

      def host_seat(item)
        new(item: item,
            icons: true,
            status: true,
            title: false,
            linkable_title: false,
            admin: false)
      end

      def receipt(item)
        new(item: item,
            icons: false,
            status: false,
            title: true,
            linkable_title: true,
            admin: false)
      end
    end
  end
end
