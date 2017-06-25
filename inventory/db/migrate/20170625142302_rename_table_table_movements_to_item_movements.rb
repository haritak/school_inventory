class RenameTableTableMovementsToItemMovements < ActiveRecord::Migration[5.1]
  def change
    rename_table :table_movements, :item_movements
  end
end
