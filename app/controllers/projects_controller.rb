# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show]

  def index
    @projects = Project.includes(project_images_attachments: :blob)
                       .all.order(name: :asc)
  end

  def gallery
    @images = GalleryImage.all_images
  end

  def show
    respond_to do |format|
      format.html
      format.json { set_workshop }
    end
  end

  private

  def set_project
    @project = Project
               .includes(stencils: [:category, { image_attachment: :blob }], project_images_attachments: :blob)
               .find params[:id]
  end

  def set_workshop
    @workshop = Workshop.find params[:workshop_id]
  end
end
