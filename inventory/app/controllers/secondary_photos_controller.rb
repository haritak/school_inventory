class SecondaryPhotosController < ApplicationController
  before_action :set_secondary_photo, only: [:show, :edit, :update, :destroy]

  # GET /secondary_photos
  # GET /secondary_photos.json
  def index
    @secondary_photos = SecondaryPhoto.all
  end

  # GET /secondary_photos/1
  # GET /secondary_photos/1.json
  def show
  end

  # GET /secondary_photos/new
  def new
    @secondary_photo = SecondaryPhoto.new
  end

  # GET /secondary_photos/1/edit
  def edit
  end

  # POST /secondary_photos
  # POST /secondary_photos.json
  def create
    @secondary_photo = SecondaryPhoto.new(secondary_photo_params)

    respond_to do |format|
      if @secondary_photo.save
        format.html { redirect_to @secondary_photo, notice: 'Secondary photo was successfully created.' }
        format.json { render :show, status: :created, location: @secondary_photo }
      else
        format.html { render :new }
        format.json { render json: @secondary_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /secondary_photos/1
  # PATCH/PUT /secondary_photos/1.json
  def update
    respond_to do |format|
      if @secondary_photo.update(secondary_photo_params)
        format.html { redirect_to @secondary_photo, notice: 'Secondary photo was successfully updated.' }
        format.json { render :show, status: :ok, location: @secondary_photo }
      else
        format.html { render :edit }
        format.json { render json: @secondary_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /secondary_photos/1
  # DELETE /secondary_photos/1.json
  def destroy
    @secondary_photo.destroy
    respond_to do |format|
      format.html { redirect_to secondary_photos_url, notice: 'Secondary photo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_secondary_photo
      @secondary_photo = SecondaryPhoto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def secondary_photo_params
      params.fetch(:secondary_photo, {})
    end
end
