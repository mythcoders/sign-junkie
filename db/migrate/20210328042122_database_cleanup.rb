class DatabaseCleanup < ActiveRecord::Migration[6.0]
  def change
    remove_column :item_descriptions, :first_name, :string
    remove_column :item_descriptions, :last_name, :string
    remove_column :item_descriptions, :email, :string
    remove_column :item_descriptions, :for_child, :boolean
    remove_column :item_descriptions, :stencil_id, :integer
    remove_column :item_descriptions, :stencil_name, :string
    remove_column :item_descriptions, :stencil_personalization, :string
  end
end
