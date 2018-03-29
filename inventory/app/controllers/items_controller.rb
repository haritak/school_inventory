class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy,
                                  :picture, :picture_thumb, 
                                  :second_picture, :invoice]

  before_action :check_can_add, only: [:new, :create]
  before_action :check_can_edit, only:[:edit, :update, :destroy]

  skip_before_action :authorize, only:[:show, :picture, 
                                       :picture_thumb, :second_picture, 
                                       :invoice, :not_found]

  Thumbs_Directory = File.join( Rails.root, "thumbnails" )
  Photos_Directory = File.join( Rails.root, "item_photos" )

  #
  # Nothing is deleted.
  # Just burned.
  #
  def destroyed
    @items = Item.where( burned: true ).order(:serial)
    render :index
  end

  # GET /items
  # GET /items.json
  def index
    if not session[:show_mine]
      @items = Item.where( burned: false).order(:serial)
    else
      @items = Item.where( user_id: session[:user_id], burned: false ).order(:serial)
    end
    return @items
  end

  def toggle_show_all_mine
    if not session[:show_mine]
      session[:show_mine] = true
    else
      session[:show_mine] = false
    end
    redirect_to items_url
  end

  def not_found
    raise "Not found" #TODO
  end

  # GET /items/1
  # GET /items/1.json
  def show
    if not @item
      redirect_to action: :not_found
    end
  end

  def picture
    return if not @item.primary_photo
    ppfilename = photo_full_path( @item.primary_photo )

    send_file(ppfilename,
              filename: "#{@item.serial}.jpeg",
              type: "image/jpeg",
              disposition: "inline")
  end

  def remove_picture_thumb
    return if not @item.primary_photo
    filename = thumb_full_path( @item.primary_photo )
    begin
      FileUtils.rm filename
    rescue 
    end
  end

  def picture_thumb
    pphoto = @item.primary_photo
    return if not pphoto

    filename = thumb_full_path( pphoto ) 

    if not File.exist?(filename)
      FileUtils.mkdir(Thumbs_Directory) if not File.exist?(Thumbs_Directory)

      `convert #{File.join(Photos_Directory,pphoto.filename)} -resize 320 #{filename}`
    end

    send_file(filename)
  end

  def second_picture
    sphoto = @item.secondary_photo
    return if not sphoto
    
    send_file(photo_full_path( sphoto ),
              filename: "#{@item.serial}-2.jpeg",
              type: "image/jpeg",
              disposition: "inline")
  end

  def invoice
    iphoto = @item.invoice_photo
    return if not iphoto

    send_file(photo_full_path( iphoto ),
              filename: "#{@item.serial}-invoice.jpg",
              type: "image/jpg",
              disposition: "inline")
  end

  # GET /items/new
  def new
    @item = Item.new
    #set who is creating
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create

    # 
    # ! item_params cannot be altered !
    #
    # Trying to delete an attribute will simply not happen (silently).
    # That's because item_params is a call to a method returning a value...
    #
    processed_params = item_params

    #following parameters are not used upon creation
    processed_params.delete :remove_photo
    processed_params.delete :remove_second_photo
    processed_params.delete :remove_invoice

    @item = Item.new(processed_params)
    @item.user_id = session[:user_id]
    @item.container_serial= params[:container_serial]

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    previous_container = @item.container
    @item.container_serial= params[:container_serial]
    if previous_container != @item.container
        #this is a movement  from container to @container
        #Log this movement
        movement = ItemMovement.create( user_id: session[:user_id],
                                       item_id: @item.id,
                                       container_id: previous_container ? previous_container.id : nil )
        movement.save
    end

    processed_params = item_params

    if processed_params[:remove_photo] == "1"
      processed_params.merge!( uploaded_picture: nil )
      puts "removing photo"
    end
    if processed_params[:remove_second_photo] == "1"
      processed_params.merge!( uploaded_second_picture: nil )
    end
    if processed_params[:remove_invoice] == "1"
      processed_params.merge!( uploaded_invoice: nil )
    end

    #we don't need them any more:
    processed_params.delete :remove_photo
    processed_params.delete :remove_second_photo
    processed_params.delete :remove_invoice

    remove_picture_thumb

    create_item_edits(@item, processed_params)

    respond_to do |format|
      if @item.update( processed_params )
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end

  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy

    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /upload_photo
  def upload_photo
  end

  #POST /upload_photo
  #Code is heavily duplicated here and in item.rb
  def search_and_place_photo
    serial_no = detect_single_serial_number(params[:uploaded_picture])
    raise "QR-code not readable." if not serial_no
    serial_no.strip!
    raise "QR-code not readable (2)." if serial_no==""
 
    item = Item.find_by( serial: serial_no )
    if item == nil 
      if not params[:create_entry]
        redirect_to(action: not_found)
        return
      elsif params[:create_entry] == "true"
        item = Item.create( serial: serial_no, user_id: session[:user_id] )
        item.save
      end
    end

    puts "Found item #{item.serial} that matches the scanned qr code."

    @item = item
    if not @item.primary_photo
      @item.update( uploaded_picture: params[:uploaded_picture] )
      redirect_to( @item ) and return
    end

    if not @item.secondary_photo
      @item.update( uploaded_second_picture: params[:uploaded_second_picture] )
      redirect_to( @item ) and return
    end

    #TODO : Allow more pictures, just do not tag them as primary or secondary
    raise "Item #{item.serial}: Both photos have been uploaded. Remove a photo to upload a new one."
  end

  # GET /upload_invoice
  def upload_invoice
  end

  #POST /upload_invoice
  #Code is heavily duplicated here and in item.rb
  def search_and_place_invoice
    uploaded_invoice = params[:uploaded_invoice]
    serials = detect_all_serial_numbers( uploaded_invoice )
    raise "QR-code not readable." if not serials
    raise "QR-code not readable." if serials.length == 0
    serials.each do |serial_no|
      serial_no.strip!
    end

    @results=[]
    serials.each do |serial_no|
      item = Item.find_by( serial: serial_no )
      if item == nil
        @results << "item #{serial_no} not found"
        next
      end

      puts "Found item #{item.serial} that matches the scanned qr code."

      @item = item
      if not @item.invoice_photo
        #@item.update( uploaded_invoice: uploaded_invoice) #true: copy_dont_move
        @item.uploaded_invoice=( uploaded_invoice, true )
        @results << "#{serial_no} OK"
        #XXX At this point, due to the @item.update above,
        #the uploaded invoice has been renamed (moved).
        #Therefore we cannot use params[:uploaded_invoice] any more.
        #We need to updated it to the newly moved file
        #uploaded_invoice = @item.invoice_photo
      else
        @results << "Item #{serial_no} already has an invoice."
      end
    end
  end

  private

  def photo_full_path( photo_item ) 
    File.join(Photos_Directory, photo_item.filename)
  end
  def thumb_full_path( photo_item ) 
    File.join(Thumbs_Directory,photo_item.thumbnail_filename)
  end

    def create_item_edits(i, p)
      p.each do |k,v|
        old_v = i.send(k)
        new_v = v
        if k.include?("uploaded") and v!=nil
          #it's an image
          sha256 = i.calc_sha256( v.tempfile )
          new_v = i.get_base_filename( sha256 )
        end

        if new_v.to_s != old_v.to_s
          #it's some other field
          item_edit = ItemEdit.new( item_id: i.id,
                                   field_name: k, old_value: old_v, 
                                   new_value: new_v,
                                   user_id: session[:user_id])
          item_edit.save

        end
      end
    end

    def detect_single_serial_number(source)
      all_serials = detect_all_serial_numbers(source)
      if all_serials.length > 1
        #two codes found, user has to input the code manually
        puts "More than one code detected in the photo. User should type the right code manually"
        serial_found = false
        raise "More than one code detected in photo"
      end
      return all_serials[0]
    end

    def detect_all_serial_numbers(source)
      apath = File.absolute_path(source.tempfile)
      scanned_qr = `zbarimg #{apath}`
      puts scanned_qr

      return nil unless scanned_qr

      serials = []
      scanned_qr.lines.each do |detected_code|
        if detected_code =~ /srv-1tee-moiron\.ira\.sch\.gr/
          puts "detected inventory code : #{detected_code}"

          code_parts = detected_code.split('/')
          next if not code_parts or code_parts.length == 0
          next if not code_parts[ code_parts.length - 1]
          next if code_parts[ code_parts.length - 1].length == 0


          serial_no = code_parts[ code_parts.length - 1 ].strip
          if serial_no.include?("?") #there are parameters at the end
            serial_no = serial_no[0, serial_no.index("?")]
          end
          serials << serial_no

          puts "->#{serial_no}<-"
        end
      end
      return serials
    end

    # Use callbacks to share common setup or constraints between actions.
    def check_can_add
      @current_user = User.find(session[:user_id])
      if not @current_user.can_add?
        raise "You need the can_add right to do that"
      end
    end

    def check_can_edit
      @current_user = User.find(session[:user_id])

      return if @current_user.is_admin?

      if not @current_user.can_edit?
        raise "You need the can_edit right to do that"
      end
    end

    def set_item
      #first try based on id
      begin
        @item = Item.find(params[:id])
      rescue ActiveRecord::RecordNotFound => nfe
      end

      #second try on serial number
      @item = Item.find_by(serial: params[:serial]) unless @item
    end

    # Never trust parameters from the scary internet, 
    # only allow the white list through.
    def item_params
      params.require(:item).permit(:serial, 
                                   :description, 
                                   :page_url, 
                                   :uploaded_picture, 
                                   :uploaded_second_picture, 
                                   :uploaded_invoice, 
                                   :item_id,
                                   :quantity,
                                   :note,
                                   :container_serial,
                                   :item_category_id,
                                   :remove_photo,
                                   :remove_second_photo,
                                   :remove_invoice,
                                   :create_entry
                                  )
    end
end
