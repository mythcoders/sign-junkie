class DropUnusedStuff < ActiveRecord::Migration[6.0]
  def change
    drop_table :clients do |t|
      t.string 'name'
      t.string 'address_1'
      t.string 'address_2'
      t.string 'state'
      t.string 'city'
      t.string 'zip_code'
      t.string 'phone'
      t.string 'fax'
      t.string 'contact_email'
      t.string 'instagram_account'
      t.string 'facebook_account'
      t.string 'twitter_account'
      t.string 'site_url'
      t.string 'site_name'
      t.string 'site_description'
      t.timestamps
    end

    drop_table :notifiications do |t|
      t.bigint 'user_id'
      t.string 'title'
      t.string 'memo'
      t.datetime 'read_date'
      t.timestamps
      t.index ['user_id'], name: 'index_notifiications_on_user_id'
    end

    remove_column :gallery_images, :caption, :string
    remove_column :projects, :description, :string
  end
end
