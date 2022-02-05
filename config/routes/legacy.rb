# frozen_string_literal: true

module Routes
  module Legacy
    extend ActionDispatch::Routing::Concern

    def draw_routes
      get "public_policies", to: redirect("/policies")
      get "public_hostess", to: redirect("/policies")
      get "private_policies", to: redirect("/policies")
      get "private_hostess", to: redirect("/policies")
      get "waiver", to: redirect("/policies")
      get "workshops/public", to: redirect("/workshops")
      get "workshops/private", to: redirect("/workshops")
    end
  end
end
