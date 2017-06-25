class CreateTableMovements < ActiveRecord::Migration[5.1]
  def change
    create_table :table_movements do |t|
      t.references :user
      t.references :item
      t.references :container
      t.timestamps
    end
  end
end
