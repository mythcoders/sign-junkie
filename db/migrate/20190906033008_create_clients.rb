class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :address_1
      t.string :address_2
      t.string :state
      t.string :city
      t.string :zip_code
      t.string :phone
      t.string :fax
      t.string :contact_email
      t.string :instagram_account
      t.string :facebook_account
      t.string :twitter_account
      t.string :site_url
      t.string :site_name
      t.string :site_description
      t.timestamps
    end
  end
end
