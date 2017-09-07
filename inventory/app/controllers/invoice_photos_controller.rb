class InvoicePhotosController < ApplicationController
  before_action :set_invoice_photo, only: [:show, :edit, :update, :destroy]

  # GET /invoice_photos
  # GET /invoice_photos.json
  def index
    @invoice_photos = InvoicePhoto.all
  end

  # GET /invoice_photos/1
  # GET /invoice_photos/1.json
  def show
  end

  # GET /invoice_photos/new
  def new
    @invoice_photo = InvoicePhoto.new
  end

  # GET /invoice_photos/1/edit
  def edit
  end

  # POST /invoice_photos
  # POST /invoice_photos.json
  def create
    @invoice_photo = InvoicePhoto.new(invoice_photo_params)

    respond_to do |format|
      if @invoice_photo.save
        format.html { redirect_to @invoice_photo, notice: 'Invoice photo was successfully created.' }
        format.json { render :show, status: :created, location: @invoice_photo }
      else
        format.html { render :new }
        format.json { render json: @invoice_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoice_photos/1
  # PATCH/PUT /invoice_photos/1.json
  def update
    respond_to do |format|
      if @invoice_photo.update(invoice_photo_params)
        format.html { redirect_to @invoice_photo, notice: 'Invoice photo was successfully updated.' }
        format.json { render :show, status: :ok, location: @invoice_photo }
      else
        format.html { render :edit }
        format.json { render json: @invoice_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoice_photos/1
  # DELETE /invoice_photos/1.json
  def destroy
    @invoice_photo.destroy
    respond_to do |format|
      format.html { redirect_to invoice_photos_url, notice: 'Invoice photo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice_photo
      @invoice_photo = InvoicePhoto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invoice_photo_params
      params.fetch(:invoice_photo, {})
    end
end
