class CreateItemEdits < ActiveRecord::Migration[5.1]
  def change
    create_table :item_edits do |t|
      t.references :item, foreign_key: true
      t.string :field_name
      t.binary :old_value, limit: 5.megabyte
      t.binary :new_value, limit: 5.megabyte
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
