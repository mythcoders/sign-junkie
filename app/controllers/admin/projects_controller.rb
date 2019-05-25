module Admin
  class ProjectsController < AdminController
    before_action :set_project, only: %i[edit update show images destroy]

    def index
      @projects = Project.order(:name).page(params[:page])
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
        flash[:success] = t('CreateSuccess')
        redirect_to admin_project_path @project
      else
        render 'new'
      end
    end

    def update
      if @project.update(project_params)
        flash[:success] = t('CreateSuccess')
        redirect_to admin_project_path @project
      else
        render 'edit'
      end
    end

    def images
      @project.project_images.attach(file_params)
      flash['success'] = t('UploadSuccess')
      redirect_to admin_project_path(@project)
    end

    def clone
      project = Project.find(project_params[:id])
      clone = project.deep_clone include: [ :project_addons, :project_stencils ]
      clone.name += ' Clone'
      if clone.save!
        flash[:success] = 'Project was successfully cloned!'
        redirect_to admin_project_path(clone)
      else
        flash[:error] = 'Sorry, an error occured.'
        redirect_to admin_project_path project
      end
    end

    def destroy
      if @project.destroy
        flash[:success] = t('DeleteSuccess')
        redirect_to admin_projects_path
      else
        flash[:error] = t('DeleteFailure')
        redirect_to admin_project_path(@project)
      end
    end

    private

    def project_params
      parameters= params.require(:project)
                        .permit(:id, :name, :description, :material_price,
                                :instructional_price, :addon_ids => [], :stencil_ids => [])
      parameters[:addon_ids].reject!(&:blank?) if parameters[:addon_ids]
      parameters[:stencil_ids].reject!(&:blank?) if parameters[:stencil_ids]
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
