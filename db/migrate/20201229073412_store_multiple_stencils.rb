class StoreMultipleStencils < ActiveRecord::Migration[6.0]
  def up
    add_column :item_descriptions, :stencils, :jsonb, null: true

    ItemDescription.where('stencil_id is not null').each do |item|
      item.stencils = [
        {
          id: item.stencil_id,
          name: item.stencil_name,
          personalization: item.stencil_personalization
        }
      ]
      item.save!
    end
  end

  def down
    remove_column :item_descriptions, :stencils
  end
end
