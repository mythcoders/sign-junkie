class CreatePerformanceIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :invoice_items, :item_description_id
    add_index :carts, :item_description_id

    remove_index :project_addons, :project_id
    remove_index :project_stencils, :stencil_id
    remove_index :seats, :workshop_id
    remove_index :workshop_projects, :workshop_id
  end
end
