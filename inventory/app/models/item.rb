class Item < ApplicationRecord
  #validates :serial, presence: true
  #
 
  belongs_to :item, optional: true
  belongs_to :user, optional: true

  def username(uid = @user_id)
    @username = "undef"
    user = User.find_by(id: uid)
    if user!=nil 
      @username = user.username
    end
    return @username
  end

  def uploaded_picture=(picture_field)

    self.photo_data = picture_field.read
    scanned_qr = `zbarimg #{File.absolute_path(picture_field.tempfile)}`

    puts scanned_qr

    return if not scanned_qr

    serial_no = ""
    found_code = false

    scanned_qr.lines.each do |detected_code|
      if detected_code =~ /srv-1tee-moiron\.ira\.sch\.gr/
        puts "detected inventory code : #{detected_code}"

        code_parts = detected_code.split('/')

        next if not code_parts or code_parts.length == 0
        next if not code_parts[ code_parts.length - 1]
        next if code_parts[ code_parts.length - 1].length == 0

        if found_code
          #two codes found, user has to input the code manually
          puts "More than one code detected in the photo. User should type the right code manually"
          found_code = false
          raise "More than one code detected in photo"
        end


        serial_no = code_parts[ code_parts.length - 1 ].strip
        if serial_no.include?("?") #there are parameters at the end
          serial_no = serial_no[0, serial_no.index("?")]
        end

        puts serial_no
        found_code = true
      end
    end

    if found_code
      if self.serial and self.serial.strip != ''
        puts "Already has a serial"
        if self.serial.strip != serial_no
          raise "Serial in database differs from serial in uploaded image"
        end
      else
        self.serial = serial_no
      end
    end

  end

  
  def uploaded_second_picture=(picture_field)
    self.photo_data2 = picture_field.read
  end

  def uploaded_invoice=(invoice_field)
    self.invoice = invoice_field.read
  end

end
