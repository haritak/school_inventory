class AddPhotodata2InvoiceToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :photo_data2, :binary
    add_column :items, :invoice, :binary
  end
end
