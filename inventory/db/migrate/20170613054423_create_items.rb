class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :serial
      t.string :description
      t.string :photo_file
      t.binary :photo_data

      t.timestamps
    end
    add_index :items, :serial, unique: true
  end
end
