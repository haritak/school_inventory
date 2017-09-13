class DeletePhotoColumnsFromItemsTable < ActiveRecord::Migration[5.1]
  def change
    remove_column :items, :photo_data
    remove_column :items, :photo_data2
    remove_column :items, :invoice
  end
end
