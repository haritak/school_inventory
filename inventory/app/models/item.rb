class Item < ApplicationRecord

  def uploaded_picture=(picture_field)

    self.photo_data = picture_field.read
    scanned_qr = `zbarimg #{File.absolute_path(picture_field.tempfile)}`



  end

end
