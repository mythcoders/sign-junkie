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
    render layout: false
  end

  def stencils
    @project = Project.includes(:stencils).find params[:id]
    render layout: false
  end

  def sidebar
    @project = Project.find params[:id]
    @addon = @project.addons.where(id: params[:addon_id]).first if params[:addon_id]
    @stencils = FrontendStencilParser.new(@project.id).parse(params[:stencils]) if params[:stencils]

    render layout: false
  end
end
