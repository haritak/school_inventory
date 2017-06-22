class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy, :picture, :second_picture, :invoice]

  skip_before_action :authorize, only:[:show, :picture, :second_picture, :invoice, :not_found]

  # GET /items
  # GET /items.json
  def index
    @items = Item.all
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
    #set who is editing/creating
    @item.user_id = session[:user_id]
  end

  # GET /items/1/edit
  def edit

    #who is trying to edit?
    user = User.find_by(id: session[:user_id])

    if not user.can_edit?
      if @item.user_id != session[ :user_id ]
        respond_to do |format|
          format.html { redirect_to items_url, notice: "#{session[:username]} is not the owner of this item." }
          format.json { head :no_content }
        end
        return
      end
    end
    @item.user_id = session[:user_id]
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    #set who is editing/creating
    @item.user_id = session[:user_id]

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

    #set who is editing/creating
    @item.user_id = session[:user_id]

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
    user = User.find_by(id: session[:user_id])
    if not user.can_edit?
      respond_to do |format|
        format.html { redirect_to items_url, notice: "#{session[:username]} is not allowed to delete." }
        format.json { head :no_content }
      end
      return
    end

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
    apath = File.absolute_path(params[:uploaded_picture].tempfile)
    scanned_qr = `zbarimg #{apath}`
    puts scanned_qr

    redirect_to(action: not_found) && return unless scanned_qr

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

    redirect_to(action: not_found) and return unless serial_found
 
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

  private

    # Use callbacks to share common setup or constraints between actions.
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
                                   :note
                                  )
    end
end
