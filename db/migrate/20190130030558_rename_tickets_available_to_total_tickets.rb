class RenameTicketsAvailableToTotalTickets < ActiveRecord::Migration[5.2]
  def change
    rename_column :workshops, :tickets_available, :total_tickets
  end
end
