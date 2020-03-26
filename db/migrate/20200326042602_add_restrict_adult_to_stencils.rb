class AddRestrictAdultToStencils < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :prohibit_adult_purchases, :boolean, default: false
    rename_column :projects, :allow_no_stencil, :stencil_optional
    rename_column :projects, :allowed_stencils, :max_stencil_selection
  end
end
