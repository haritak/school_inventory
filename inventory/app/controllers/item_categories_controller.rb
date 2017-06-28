class ItemCategoriesController < ApplicationController
  before_action :set_item_category, only: [:show, :edit, :update]

  def index
    @item_categories = ItemCategory.all.order(:category)
  end
 


  # GET /item_categories/new
  def new
    @item_category = ItemCategory.new
  end

  # GET /item_categories/1/edit
  def edit
  end

  # PATCH/PUT /items/1
  def update
    respond_to do |format|
      if @item_category.update(item_category_params)
        format.html { redirect_to @item_category, notice: 'Item category was successfully updated.' }
        format.json { render :show, status: :ok, location: @item_category }
      else
        format.html { render :edit }
        format.json { render json: @item_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /item_categories
  def create
    @item_category = ItemCategory.new(item_category_params)

    respond_to do |format|
      if @item_category.save
        format.html { redirect_to @item_category, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item_category }
      else
        format.html { render :new }
        format.json { render json: @item_category.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # GET /items/1
  def show
  end
 
  private 

    def set_item_category
      @item_category = ItemCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, 
    # only allow the white list through.
    def item_category_params
      params.require(:item_category).permit(
                                   :category, 
                                   :description
                                  )
    end

end
