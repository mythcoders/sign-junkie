module Admin
  class ProjectsController < AdminController
    before_action :set_project, only: %i[edit update show]

    def index
      @projects = Project.page(params[:page]).per(10)
    end

    def new
      @project = Project.new
    end

    def show
      @addon = Addon.new(project: @project)
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

    private

    def project_params
      params.require(:project).permit(:id, :name, :description,
                                      project_addon_attributes: [:id, :addon_id])
    end

    def set_project
      @project = Project.find(params[:id])
    end

    def set_addons
      @addons = AddOns.all
    end
  end
end
