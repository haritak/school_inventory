class ItemEditsController < ApplicationController
  before_action :set_edit, only: [:destroy]

  def index
    @item_edits = ItemEdit.all.order(:created_at)
  end

  def destroy

    @item_edit.destroy

    respond_to do |format|
      format.html { redirect_to item_edits_url, notice: 'Edit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_edit
      @item_edit = ItemEdit.find(params[:id])
    end

end
