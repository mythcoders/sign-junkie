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

  private

  def set_project
    @project = Project
               .includes(stencils: [:category, { image_attachment: :blob }], project_images_attachments: :blob)
               .find params[:id]
  end
end
