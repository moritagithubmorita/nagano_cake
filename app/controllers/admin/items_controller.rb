class Admin::ItemsController < ApplicationController
  def index
    @items = Item.page(params[:page]).per(10).reverse_order
  end

  def new
    @item = Item.new
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
  end
  
  def create
    Item.create(item_params)
  end
  
  def update
    Item.find(params[:id]).update(item_params)
  end
  
  private
  
  def item_params
    params.require(:item).permit(:genre_id, :name, :image_id, :introduction, :price, :is_active)
  end

end
