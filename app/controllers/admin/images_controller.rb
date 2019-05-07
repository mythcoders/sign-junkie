module Admin
  class ImagesController < AdminController
    before_action :set_workshop, only: %i[workshop]
    before_action :set_project, only: %i[project]
    before_action :set_addon, only: %i[addon]

    def destory

    end

    private

    def set_workshop
      @workshop = Workshop.find params[:id]
    end

    def set_project
      @project = Project.find params[:id]
    end

    def set_addon
      @addon = Addon.find params[:id]
    end
  end
end
