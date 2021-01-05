# frozen_string_literal: true

class ProjectsController < ApplicationController
  def index
    @projects = Project.includes(project_images_attachments: :blob)
                       .active
                       .order(name: :asc)
  end

  def show
    @project = Project
               .includes(stencils: [:category, { image_attachment: :blob }], project_images_attachments: :blob)
               .find params[:id]
  end

  def gallery
    @images = GalleryImage.all_images
  end

  def addons
    @project = Project.includes(:addons).find params[:id]
    @selection = params[:selection]

    render layout: false
  end

  def stencils
    @project = Project.includes(:stencils).find params[:id]
    @selection = params[:selection]

    render layout: false
  end

  # sidebar when building a seat with the SeatWizard
  def sidebar
    @project = Project.find params[:id]
    @addon = @project.addons.find(params[:addon_id]) if params[:addon_id] != ''
    @stencils = SeatService::StencilParser.parse(@project.id, params[:stencils]) if params[:stencils] != ''

    render layout: false
  end
end
