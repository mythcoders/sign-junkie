class DeleteStencilCategoriesParentId < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :stencil_categories, :stencil_categories, column: :parent_id
  end
end
