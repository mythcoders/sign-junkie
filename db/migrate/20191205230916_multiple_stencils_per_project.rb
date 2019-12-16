class MultipleStencilsPerProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :allowed_stencils, :integer, default: 1
  end
end
