# frozen_string_literal: true

# Define a module with a #draw_routes method (e.g. `YourRoutesModule`).
# Call `extend ActionDispatch::Routing::Concern` inside that module.
# Then call `extend YourRoutesModule` inside the Rails.application.routes.draw block.
# `#draw_routes` will be called in the current context (namespace, constraints, etc.)
module ActionDispatch
  module Routing
    module Concern
      def extended(mod)
        mod.instance_exec do
          draw_routes
        end
      end
    end
  end
end

# Reload routes during development if a file changes in config/routes/*
Rails.application.configure do
  route_reload_paths = {
    Rails.root.join("config", "routes").to_s => ["rb"]
  }
  route_reloader = config.file_watcher.new([], route_reload_paths) do
    reload_routes!
  end
  reloaders << route_reloader
  config.to_prepare { route_reloader.execute_if_updated }
end
