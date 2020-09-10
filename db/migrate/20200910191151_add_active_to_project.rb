class AddActiveToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :active, :boolean, default: true, null: false
    add_column :stencils, :active, :boolean, default: true, null: false
  end
end
