class IncreaseItemsPhotoDataSize < ActiveRecord::Migration[5.1]
  def change
    change_column :items, :photo_data, :binary, limit: 5.megabyte
  end
end
