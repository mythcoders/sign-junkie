# frozen_string_literal: true

module Admin
  class ProjectsController < AdminController
    before_action :set_project, only: %i[edit update show destroy new_image upload_images]

    def index
      @projects_grid = initialize_grid(Project,
                                       order: 'name')
    end

    def show
      @addon = ProjectAddon.new(project_id: @project.id)
    end

    def new
      @project = Project.new
    end

    def create
      @project = Project.new(project_params)

      if @project.save
        flash[:success] = t('create.success')
        redirect_to admin_project_path @project
      else
        render 'new'
      end
    end

    def update
      if @project.update(project_params)
        flash[:success] = t('update.success')
        redirect_to admin_project_path @project
      else
        render 'edit'
      end
    end

    def upload_images
      Rails.logger.debug '#upload_images'
      @project.project_images.attach(file_params)
      flash['success'] = t('upload.success')
      redirect_to admin_project_path(@project)
    end

    def clone
      project = Project.find(project_params[:id])
      clone = project.deep_clone include: %i[project_addons project_stencils]
      clone.name += ' copy'
      if clone.save!
        flash[:success] = 'Project was successfully cloned!'
        redirect_to admin_project_path(clone)
      else
        flash[:error] = 'Sorry, an error occurred.'
        redirect_to admin_project_path project
      end
    end

    def destroy
      if @project.destroy
        flash[:success] = t('destroy.success')
        redirect_to admin_projects_path
      else
        flash[:error] = t('destroy.failure')
        redirect_to admin_project_path(@project)
      end
    end

    private

    def project_params
      parameters = params.require(:project)
                         .permit(:id, :name, :description, :material_price, :allow_no_stencil, :allowed_stencils,
                                 :instructional_price, addon_ids: [], stencil_ids: [])
      parameters[:addon_ids]&.reject!(&:blank?)
      parameters[:stencil_ids]&.reject!(&:blank?)
      parameters
    end

    def file_params
      params[:project][:images]
    end

    def set_project
      @project = Project.includes(:addons, :stencils).find(params[:id])
    end
  end
end
