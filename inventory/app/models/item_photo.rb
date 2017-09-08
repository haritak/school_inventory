class ItemPhoto < ApplicationRecord
  belongs_to :item

  def thumbnail_filename
    File.basename( filename, ".*" ) + "_thumb.jpg"
  end

end
