class CancelDateForWorkshops < ActiveRecord::Migration[5.2]
  def change
    add_column :workshops, :cancel_date, :datetime, null: true
  end
end
