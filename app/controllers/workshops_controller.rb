# frozen_string_literal: true

class WorkshopsController < ApplicationController
  before_action :set_workshop, only: %i[show project]
  before_action :set_project, only: %i[project]
  before_action :set_cart_total, only: %i[show]

  private

  def set_workshop
    @workshop = Workshop.find(params[:id])
  end

  def set_project
    @project = Project.find(params[:project_id])
  end
end
