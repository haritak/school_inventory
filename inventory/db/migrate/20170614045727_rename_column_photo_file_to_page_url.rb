class RenameColumnPhotoFileToPageUrl < ActiveRecord::Migration[5.1]
  def change
    rename_column :items, :photo_file, :page_url
  end
end
