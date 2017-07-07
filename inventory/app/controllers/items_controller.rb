class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy, :picture, :picture_thumb, :second_picture, :invoice]

  before_action :check_can_add, only: [:new, :create]
  before_action :check_can_edit, only:[:edit, :update, :destroy]

  skip_before_action :authorize, only:[:show, :picture, :picture_thumb, :second_picture, :invoice, :not_found]

  # GET /items
  # GET /items.json
  def index
    if not session[:show_mine]
      @items = Item.all.order(:serial)
    else
      @items = Item.where( user_id: session[:user_id] ).order(:serial)
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
  end

  # GET /items/1
  # GET /items/1.json
  def show
    if not @item
      redirect_to action: :not_found
    end
  end

  def picture
    return if not @item
    return if not @item.photo_data
    send_data(@item.photo_data,
              filename: "#{@item.serial}.jpeg",
              type: "image/jpeg",
              disposition: "inline")
  end

  def picture_thumb
    return if not @item
    return if not @item.photo_data
    thumbnail = "#{@item.serial}-photo_data-thumb.jpg"

    filename = "thumbnails/#{thumbnail}"
    
    tmp_filename = "#{filename}.tmp"
    if not File.exist?(filename)
      FileUtils.mkdir("thumbnails") if not File.exist?("thumbnails")

      File.open( tmp_filename, "wb") do |f|
        f.write @item.photo_data
      end
      `convert #{tmp_filename} -resize 320 #{filename}`
    elsif File.exist?(tmp_filename)
      FileUtils.rm tmp_filename
    end

    send_file(filename)
  end

  def second_picture
    return if not @item
    return if not @item.photo_data2
    send_data(@item.photo_data2,
              filename: "#{@item.serial}-2.jpeg",
              type: "image/jpeg",
              disposition: "inline")
  end

  def invoice
    return if not @item
    return if not @item.invoice
    send_data(@item.invoice,
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
    @item = Item.new(item_params)
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

    create_item_edits(@item, item_params)

    respond_to do |format|
      if @item.update(item_params)
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
    serial_no = detect_serial_number(params[:uploaded_picture])
    if not serial_no
      redirect_to(action: not_found) 
      return 
    end
 
    item = Item.find_by( serial: serial_no )
    if item == nil
      redirect_to(action: not_found)
      return
    end

    puts "Found item #{item.serial} that matches the scanned qr code."

    @item = item
    if not @item.photo_data
      @item.photo_data = params[:uploaded_picture].read
      @item.update( photo_data: @item.photo_data )
      redirect_to( @item ) and return
    end

    @item.photo_data2 = params[:uploaded_picture].read
    @item.update( photo_data2: @item.photo_data2 )
    redirect_to( @item ) and return
  end

  # GET /upload_invoice
  def upload_invoice
  end

  #POST /upload_invoice
  #Code is heavily duplicated here and in item.rb
  def search_and_place_invoice
    serial_no = detect_serial_number( params[:uploaded_invoice] )

    if not serial_no
      redirect_to(action: not_found)
      return
    end
 
    item = Item.find_by( serial: serial_no )
    if item == nil
      redirect_to(action: not_found)
      return
    end

    puts "Found item #{item.serial} that matches the scanned qr code."

    @item = item
    if not @item.invoice
      @item.invoice = params[:uploaded_invoice].read
      @item.update( invoice: @item.invoice )
      redirect_to( @item ) and return
    else
      raise "Item already has an invoice."
    end
  end

  private

    def create_item_edits(i, p)
      p.each do |k,v|
        old_v = i.send(k)
        new_v = v
        if k.include?("photo") or k.include?("invoice")
          #it's an image
          new_v = v.read
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

    def detect_serial_number(source)
      apath = File.absolute_path(source.tempfile)
      scanned_qr = `zbarimg #{apath}`
      puts scanned_qr

      return nil unless scanned_qr

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

          puts "->#{serial_no}<-"
          serial_found = true
        end
      end
      return serial_no
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
                                  )
    end
end
