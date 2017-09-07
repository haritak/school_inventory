class AddColumnTypeToItemPhotos < ActiveRecord::Migration[5.1]
  def change
    add_column :item_photos, :type, :string
  end
end
