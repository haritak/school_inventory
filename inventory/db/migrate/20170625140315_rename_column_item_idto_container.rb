class RenameColumnItemIdtoContainer < ActiveRecord::Migration[5.1]
  def change
    rename_column :items, :item_id, :container_id
  end
end
