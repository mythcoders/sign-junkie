class CreateEmailLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :email_logs do |t|
      t.references :user, null: false, index: true
      t.string :subject, null: false
      t.timestamps
    end
  end
end
