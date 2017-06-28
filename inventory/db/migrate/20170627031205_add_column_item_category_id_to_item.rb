class AddColumnItemCategoryIdToItem < ActiveRecord::Migration[5.1]
  def change
    add_reference :items, :item_category, foreign_key: true
  end
end
