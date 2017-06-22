class AddNoteToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :note, :text
  end
end
