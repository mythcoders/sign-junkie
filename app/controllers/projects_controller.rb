class ProjectsController < ApplicationController
  def index
    @projects = Project.all.order(name: :asc)
  end

  def addons
    @addons = Addon.active
  end

  def show

  end
end
