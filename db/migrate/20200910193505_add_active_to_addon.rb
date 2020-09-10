class AddActiveToAddon < ActiveRecord::Migration[5.2]
  def change
    add_column :addons, :active, :boolean, default: true, null: false
  end
end
