# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show addons stencils sidebar]

  def index
    @projects = Project.includes(project_images_attachments: :blob)
                       .active
                       .order(name: :asc)
  end

  def gallery
    @images = GalleryImage.all_images
  end

  def addons
    render layout: false
  end

  def stencils
    render layout: false
  end

  def sidebar
    @addon = @project.addons.where(id: params[:addon_id]).first if params[:addon_id]
    @stencils = @project.stencils.where(id: params[:stencil_ids]) if params[:stencil_ids]

    render layout: false
  end

  private

  def set_project
    @project = Project
               .includes(stencils: [:category, { image_attachment: :blob }], project_images_attachments: :blob)
               .find params[:id]
  end
end
