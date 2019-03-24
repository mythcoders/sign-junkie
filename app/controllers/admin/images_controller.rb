module Admin
  class ImagesController < AdminController
    before_action :set_workshop, only: %i[workshop]
    before_action :set_project, only: %i[project]

    def destory

    end

    private

    def set_workshop
      @workshop = Workshop.find params[:id]
    end

    def set_project
      @project = Project.find params[:id]
    end
  end
end
