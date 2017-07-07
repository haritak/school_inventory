class RenameColumnDestroyedToBurnedInItems < ActiveRecord::Migration[5.1]
  def change
    rename_column :items, :destroyed, :burned
  end
end
