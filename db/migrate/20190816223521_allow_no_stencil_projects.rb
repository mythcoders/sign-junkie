class AllowNoStencilProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :allow_no_stencil, :boolean, null: false, default: false
  end
end
