class ProjectsController < ApplicationController
  def index
    @projects = Project.all.order(name: :asc)
  end
end
