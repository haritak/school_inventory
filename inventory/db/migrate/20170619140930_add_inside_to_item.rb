class AddInsideToItem < ActiveRecord::Migration[5.1]
  def change
    add_reference :items, :item, foreign_key: true
  end
end
