class PrimaryPhotosController < ApplicationController
  before_action :set_primary_photo, only: [:show, :edit, :update, :destroy]

  # GET /primary_photos
  # GET /primary_photos.json
  def index
    @primary_photos = PrimaryPhoto.all
  end

  # GET /primary_photos/1
  # GET /primary_photos/1.json
  def show
  end

  # GET /primary_photos/new
  def new
    @primary_photo = PrimaryPhoto.new
  end

  # GET /primary_photos/1/edit
  def edit
  end

  # POST /primary_photos
  # POST /primary_photos.json
  def create
    @primary_photo = PrimaryPhoto.new(primary_photo_params)

    respond_to do |format|
      if @primary_photo.save
        format.html { redirect_to @primary_photo, notice: 'Primary photo was successfully created.' }
        format.json { render :show, status: :created, location: @primary_photo }
      else
        format.html { render :new }
        format.json { render json: @primary_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /primary_photos/1
  # PATCH/PUT /primary_photos/1.json
  def update
    respond_to do |format|
      if @primary_photo.update(primary_photo_params)
        format.html { redirect_to @primary_photo, notice: 'Primary photo was successfully updated.' }
        format.json { render :show, status: :ok, location: @primary_photo }
      else
        format.html { render :edit }
        format.json { render json: @primary_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /primary_photos/1
  # DELETE /primary_photos/1.json
  def destroy
    @primary_photo.destroy
    respond_to do |format|
      format.html { redirect_to primary_photos_url, notice: 'Primary photo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_primary_photo
      @primary_photo = PrimaryPhoto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def primary_photo_params
      params.fetch(:primary_photo, {})
    end
end
