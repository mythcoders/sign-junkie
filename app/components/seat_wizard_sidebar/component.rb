# frozen_string_literal: true

module SeatWizardSidebar
  class Component < ViewComponent::Base
    def initialize(project, addon, stencils)
      @project = project
      @addon = addon
      @stencils = stencils&.collect { |h| HashWithIndifferentAccess.new h }
    end

    def total_price
      if @addon
        @project.total_price + @addon.price
      else
        @project.total_price
      end
    end
  end
end
