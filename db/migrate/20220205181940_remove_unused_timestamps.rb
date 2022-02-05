class RemoveUnusedTimestamps < ActiveRecord::Migration[7.0]
  def change
    remove_timestamps :project_addons
    remove_timestamps :project_stencils
    remove_timestamps :workshop_projects
  end
end
