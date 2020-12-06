# frozen_string_literal: true

module SearchNavigationTabs
  class Component < ViewComponent::Base
    def initialize(tabs:, path:, params:)
      @tabs = tabs
      @path = path
      @params = params
      @current_tab = params[:scope]
    end

    def scope_path(scope)
      send(@path, @params.permit(:scope).merge(scope: scope))
    end
  end
end
