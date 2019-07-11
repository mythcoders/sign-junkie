# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show]

  def index
    @projects = Project.all.order(name: :asc)
  end

  def show
    respond_to do |format|
      format.html
      format.json { set_workshop }
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def set_workshop
    @workshop = Workshop.find(params[:workshop_id])
  end
end
