class RenameEventsToWorkshops < ActiveRecord::Migration[5.2]
  def change
    rename_table :events, :workshops
    rename_column :cart_items, :event_id, :workshop_id
    rename_column :order_items, :event_id, :workshop_id
  end
end
