class AddColumnDescriptionToItemPhotos < ActiveRecord::Migration[5.1]
  def change
    add_column :item_photos, :description, :string
  end
end
