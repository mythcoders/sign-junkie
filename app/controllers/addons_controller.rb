# frozen_string_literal: true

class AddonsController < ApplicationController
  def index
    @addons = Addon.active
  end
end
