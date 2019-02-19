module Admin
  class ProjectsController < AdminController
    before_action :set_project, only: %i[edit update show]
    before_action :set_designs, only: %i[edit update]

    def index
      @projects = Project.page(params[:page]).per(10)
    end

    def new
      @project = Project.new
      @project.designs.build
    end

    def show
      @addon = Addon.new(project: @project)
    end

    def create
      @project = Project.new(project_params)
      # project.design_ids = Design.find(project_params[:design_ids])
      if @project.save
        flash[:success] = t('CreateSuccess')
        redirect_to admin_project_path @project
      else
        render 'new'
      end
    end

    def update
      @project.design_ids = Design.find(project_params[:design_ids])
      if @project.update(project_params)
        flash[:success] = t('CreateSuccess')
        redirect_to admin_project_path @project
      else
        render 'edit'
      end
    end

    private

    def project_params
      params.require(:project).permit(:id, :name, :description, design_ids: [],
                                      project_addon_attributes: [:id, :addon_id])
    end

    def set_designs
      @designs = Design.all.collect { |opt| [opt.name, opt.id] }
    end

    def set_project
      @project = Project.includes(:addons, :designs).find(params[:id])
    end

    def set_addons
      @addons = AddOns.all
    end
  end
end
