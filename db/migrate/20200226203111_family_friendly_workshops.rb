class FamilyFriendlyWorkshops < ActiveRecord::Migration[5.2]
  def change
    add_column :workshops, :family_friendly, :boolean, default: false
  end
end
