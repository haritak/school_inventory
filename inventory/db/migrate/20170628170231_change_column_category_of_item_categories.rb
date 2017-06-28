class ChangeColumnCategoryOfItemCategories < ActiveRecord::Migration[5.1]
  def change
    change_column :item_categories, :category, :string, null:false
    add_index :item_categories, :category, unique: true
  end
end
