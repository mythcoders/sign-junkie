class RestrictStencilPersonlization < ActiveRecord::Migration[5.2]
  def change
    add_column :stencils, :allow_personilization, :boolean, default: false
  end
end
