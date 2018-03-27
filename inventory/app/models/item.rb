class Item < ApplicationRecord
  ##validates :serial, presence: true
  #
  #The serial may be hidden inside the photo, so it's ok
  #to submit without a serial
  
  belongs_to :container, optional: true, class_name: "Item"
  belongs_to :user, optional: true
  belongs_to :item_category, optional: true

  has_many :item_photos
  has_one :primary_photo
  has_one :secondary_photo
  has_one :invoice_photo

  def destroy
    self.burned = true
    self.save
  end

  def username(uid = @user_id)
    @username = "undef"
    @user = User.find_by(id: uid)
    if @user!=nil 
      @username = user.username
    end
    return @username
  end

  def container_serial=(serial)
    container = Item.find_by( serial: serial )
    if not container
      #second try
      container = Item.where( "lower(serial) like '%#{serial.downcase}%'" ).first
    end

    if container 
      @container = container
      update( container: @container )
    end

    if serial == "none"
      update( container: nil )
    end
  end

  def container_serial(container_id=nil)
    if container_id
      @container = Item.find( container_id )
      return @container.serial
    else
      if @container_id
        @container = Item.find( @container_id )
        return @container.serial
      end
    end
    return nil
  end


  def uploaded_picture
    self.primary_photo ? self.primary_photo.filename : nil
  end
  def uploaded_second_picture
    self.secondary_photo ? self.secondary_photo.filename : nil
  end
  def uploaded_invoice
    self.invoice_photo ? self.invoice_photo.filename : nil
  end


  #Code is heavily duplicated here and in items_controller.rb
  def uploaded_picture=(picture_field)

    if picture_field==nil
      remove_photo_file( 1 )
      return
    end

    new_filename = accept_photo_file( picture_field.tempfile )

    #Try to get the qrcode, but don't fail on that
    scanned_qr = `zbarimg #{File.absolute_path( new_filename )}`
    puts scanned_qr

    return if not scanned_qr
    
    #
    #Do the rest only if a scanned code is detected
    #

    serial_no = ""
    serial_found = false

    scanned_qr.lines.each do |detected_code|
      if detected_code =~ /srv-1tee-moiron\.ira\.sch\.gr/
        puts "detected inventory code : #{detected_code}"

        code_parts = detected_code.split('/')

        next if not code_parts or code_parts.length == 0
        next if not code_parts[ code_parts.length - 1]
        next if code_parts[ code_parts.length - 1].length == 0

        if serial_found
          #two codes found, user has to input the code manually
          puts "More than one code detected in the photo. User should type the right code manually"
          serial_found = false
          raise "More than one code detected in photo"
        end


        serial_no = code_parts[ code_parts.length - 1 ].strip
        if serial_no.include?("?") #there are parameters at the end
          serial_no = serial_no[0, serial_no.index("?")]
        end

        puts serial_no
        serial_found = true
      end
    end

    if serial_found
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

    if picture_field == nil
      remove_photo_file( 2 )
      return
    end

    accept_photo_file( picture_field.tempfile, 2 )
  end

  def uploaded_invoice=(invoice_field)

    if invoice_field == nil
      remove_photo_file( 3 )
      return
    end

    accept_photo_file( invoice_field.tempfile, 3 )
  end

  def get_immediate_contents
    a = Item.where( container_id: self.id )
  end

  def calc_sha256( tmp_file )
    sha256 = `sha256sum #{File.absolute_path(tmp_file)}`

    raise "SHA256 calculation error." if not sha256
    raise "SHA256 calculation error." if sha256.length==0
    sha256 = sha256.split()
    raise "SHA256 calculation error." if sha256.length==0
    sha256 = sha256[0]
    raise "SHA256 calculation error." if sha256.length<10

    return sha256
  end

  def get_base_filename( sha256 )
    "#{sha256}.jpg"
  end

  def get_image_filename( sha256 ) 
    base_filename = get_base_filename( sha256 )
    File.join(ItemsController::Photos_Directory, base_filename)
  end

  private

  # photo_type:
  #  1 - primary photo
  #  2 - secondary photo
  #  3 - invoice photo
  #  other - just a photo
  def accept_photo_file( tmp_file, photo_type = 1 )
    #Calculate sha256 used as the base filename
    sha256 = calc_sha256( tmp_file )
    puts sha256

    #move the uploaded file to our Photos_Directory
    uploaded_filename = File.absolute_path( tmp_file )
    stored_filename = File.absolute_path( get_image_filename( sha256 )  )
    FileUtils.mv( uploaded_filename, stored_filename )

    #file the photo 
    pp = nil
    if photo_type == 1
      pp = PrimaryPhoto.create( item: self,
                               filename: "#{sha256}.jpg" )
    elsif photo_type == 2
      pp = SecondaryPhoto.create( item: self,
                               filename: "#{sha256}.jpg" )
    elsif photo_type == 3
      pp = InvoicePhoto.create( item: self,
                               filename: "#{sha256}.jpg" )
    else
      pp = ItemPhoto.create( item: self,
                               filename: "#{sha256}.jpg" )
    end

    pp.save

    return stored_filename

  end

  def remove_photo_file( photo_type = 1 )
    target = nil
    case photo_type
    when 1
      target = self.primary_photo
    when 2
      target = self.secondary_photo
    when 3
      target = self.invoice_photo
    end

    target.destroy if target
    #actually the file is not removed for tracing reasons

  end

end
