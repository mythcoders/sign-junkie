class MigrateWorkshopDescriptionsToActionText < ActiveRecord::Migration[6.0]
  include ActionView::Helpers::TextHelper

  def up
    rename_column :workshops, :description, :description_old
    Workshop.all.each do |ws|
      ws.update_attribute(:description, simple_format(ws.description_old))
    end
    remove_column :workshops, :description_old
  end

  def down
    add_column :workshops, :description
  end
end
