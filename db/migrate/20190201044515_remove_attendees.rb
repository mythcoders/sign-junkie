class RemoveAttendees < ActiveRecord::Migration[5.2]
  def change
    drop_table :attendees
    change_table :order_items do |t|
      t.string :attendee
      t.string :email
      t.rename :name, :description
    end
  end
end
