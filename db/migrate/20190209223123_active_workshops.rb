class ActiveWorkshops < ActiveRecord::Migration[5.2]
  def change
    rename_column :workshops, :posting_start_date, :purchase_start_date
    rename_column :workshops, :posting_end_date, :purchase_end_date
  end
end
