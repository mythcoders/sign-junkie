class CreateAnnouncements < ActiveRecord::Migration[6.0]
  def change
    create_table :announcements do |t|
      t.string :title, null: false
      t.datetime :start_at
      t.datetime :end_at
      t.timestamps
    end
  end
end
