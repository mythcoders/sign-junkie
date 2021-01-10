# frozen_string_literal: true

module ItemDescriptionDisplay
  class Component < ViewComponent::Base
    include IconHelper

    def initialize(args = {})
      @item = args[:item]
      @show_icons = args[:icons].nil? ? true : args[:icons]
      @show_status = args[:status].nil? ?  true : args[:status]
      @show_title = args[:title].nil? ? true : args[:title]
      @linkable = args[:linkable].nil? ? false : args[:linkable]
      @admin = args[:admin].nil? ? false : args[:admin]
      @show_workshop = args[:show_workshop].nil? ? true : args[:show_workshop]
    end

    class << self
      def default(item)
        new(item: item)
      end

      def linkable(item)
        new(item: item, linkable: true)
      end

      def admin(item)
        new(item: item, admin: true)
      end

      def receipt(item)
        new(item: item,
            icons: false,
            status: false)
      end
    end
  end
end
