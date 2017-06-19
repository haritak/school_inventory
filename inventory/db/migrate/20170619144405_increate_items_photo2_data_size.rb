class IncreateItemsPhoto2DataSize < ActiveRecord::Migration[5.1]
  def change
    change_column :items, :photo_data2, :binary, limit: 5.megabyte
    change_column :items, :invoice, :binary, limit: 5.megabyte
  end
end
