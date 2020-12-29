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
    @stencils = find_stencils(params[:stencils]) if params[:stencils]

    render layout: false
  end

  private

  def find_stencils(stencil_input)
    stencil_input.split('::').map do |stencil|
      id = stencil.split('|')[0]
      personalization = stencil.split('|')[1]

      OpenStruct.new(
        name: @project.stencils.where(id: id).first.name,
        personalization: personalization != 'null' ? personalization : nil
      )
    end
  end
end
