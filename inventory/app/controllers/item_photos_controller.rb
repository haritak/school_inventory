class ItemPhotosController < ApplicationController
  before_action :set_item_photo, only: [:show, :edit, :update, :destroy]

  # GET /item_photos
  # GET /item_photos.json
  def index
    @item_photos = ItemPhoto.all
  end

  # GET /item_photos/1
  # GET /item_photos/1.json
  def show
  end

  # GET /item_photos/new
  def new
    @item_photo = ItemPhoto.new
  end

  # GET /item_photos/1/edit
  def edit
  end

  # POST /item_photos
  # POST /item_photos.json
  def create
    @item_photo = ItemPhoto.new(item_photo_params)

    respond_to do |format|
      if @item_photo.save
        format.html { redirect_to @item_photo, notice: 'Item photo was successfully created.' }
        format.json { render :show, status: :created, location: @item_photo }
      else
        format.html { render :new }
        format.json { render json: @item_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /item_photos/1
  # PATCH/PUT /item_photos/1.json
  def update
    respond_to do |format|
      if @item_photo.update(item_photo_params)
        format.html { redirect_to @item_photo, notice: 'Item photo was successfully updated.' }
        format.json { render :show, status: :ok, location: @item_photo }
      else
        format.html { render :edit }
        format.json { render json: @item_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /item_photos/1
  # DELETE /item_photos/1.json
  def destroy
    @item_photo.destroy
    respond_to do |format|
      format.html { redirect_to item_photos_url, notice: 'Item photo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item_photo
      @item_photo = ItemPhoto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_photo_params
      params.fetch(:item_photo, {})
    end
end
