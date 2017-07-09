class ItemMovementsController < ApplicationController
  def index(item=nil)
    if not item
      @item_movements = ItemMovement.all
    else
      @item_movements = ItemMovement.where( item_id: item.id )
    end
  end

  def self.last_editor(item)
    "TODO" #TODO
  end
end
