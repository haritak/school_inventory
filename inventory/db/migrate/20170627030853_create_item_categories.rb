class CreateItemCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :item_categories do |t|
      t.string :category
      t.text :description

      t.timestamps
    end
  end
end
