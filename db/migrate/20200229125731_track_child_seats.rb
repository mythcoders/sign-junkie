class TrackChildSeats < ActiveRecord::Migration[5.2]
  def change
    add_column :item_descriptions, :for_child, :boolean, default: false
    add_column :item_descriptions, :gifted, :boolean, default: false

    ItemDescription
      .where("item_type = 'seat' and email IS NOT NULL")
      .update_all(gifted: true)

    ItemDescription
      .where("item_type = 'seat' and first_name IS NOT NULL and last_name IS NOT NULL")
      .update_all(gifted: true)
  end
end
