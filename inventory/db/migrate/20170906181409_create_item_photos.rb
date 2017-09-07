class CreateItemPhotos < ActiveRecord::Migration[5.1]
  def change
    create_table :item_photos do |t|
      t.belongs_to :item, foreign_key: true
      t.string :filename
      t.integer :priority

      t.timestamps
    end

    add_index :item_photos, :filename, unique: true

  end
end
