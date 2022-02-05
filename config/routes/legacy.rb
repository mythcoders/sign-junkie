# frozen_string_literal: true

module Routes
  module Legacy
    extend ActionDispatch::Routing::Concern

    def draw_routes
      get "public_policies", to: redirect("/policies")
      get "public_hostess", to: redirect("/policies")
      get "private_policies", to: redirect("/policies")
      get "private_hostess", to: redirect("/policies")
    end
  end
end
