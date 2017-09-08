class DestroyIndexOfItemPhotos < ActiveRecord::Migration[5.1]
  def change
    remove_index :item_photos, name: :index_item_photos_on_filename
  end
end
