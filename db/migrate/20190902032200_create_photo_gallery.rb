class CreatePhotoGallery < ActiveRecord::Migration[5.2]
  def change
    create_table :gallery_images do |t|
      t.string :caption
      t.integer :sort
      t.timestamps
    end
  end
end
