class ItemMovementsController < ApplicationController
  def index
    if not params[:id]
      @item_movements = ItemMovement.all
    else
      @item_movements = ItemMovement.where( item_id: params[:id] )
    end
  end

  def self.last_editor(item)
    "TODO" #TODO
  end
end
