class ItemMovementsController < ApplicationController
  def index
    @item_movements = ItemMovement.all
  end
end
