class AddonsController < ApplicationController
  def index
    @addons = Addon.active
  end
end
