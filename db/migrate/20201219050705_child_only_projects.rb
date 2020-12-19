class ChildOnlyProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :only_for_children, :boolean, default: false, null: false
  end
end
