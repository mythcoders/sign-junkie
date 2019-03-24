module Admin
  class ProjectsController < AdminController
    before_action :set_project, only: %i[edit update show images]
    before_action :set_designs, only: %i[edit update]

    def index
      @projects = Project.page(params[:page]).per(10)
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
      @project.design_ids = Stencil.find(project_params[:design_ids])
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

    private

    def project_params
      params.require(:project).permit(:id, :name, :description, :price)
    end

    def file_params
      params[:project][:images]
    end

    def set_designs
      @designs = Design.all.collect { |opt| [opt.name, opt.id] }
    end

    def set_project
      @project = Project.includes(:addons, :stencils).find(params[:id])
    end
  end
end
