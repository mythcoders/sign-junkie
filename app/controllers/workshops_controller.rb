# frozen_string_literal: true

class WorkshopsController < ApplicationController
  before_action :set_workshop, only: %i[show project_info]

  def public
    @workshops = Workshop.upcoming.public_shops
  end

  def private
    @workshops = Workshop.upcoming.private_shops
  end

  def project_info
    @project = Project.find(params[:project_id])
  end

  private

  def set_workshop
    @workshop = Workshop.find(params[:id])
  end
end
