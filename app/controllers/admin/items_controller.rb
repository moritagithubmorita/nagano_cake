class Admin::ItemsController < ApplicationController
  skip_before_action :authenticate_customer!
  before_action :authenticate_admin!

  def index
    @items = Item.page(params[:page]).per(10)
  end

  def new
    @added_item = Item.new
    @item = Item.new
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @added_item = Item.new
    @item = Item.find(params[:id])
  end

  def create
    @added_item = Item.new(item_params)

    if @added_item.save
      redirect_to admin_item_path(@added_item.id)
    else
      @item = Item.new
      render :new
    end
  end

  def update
    @added_item = Item.find(params[:id])
    if @added_item.update(item_params)
      redirect_to admin_item_path(@added_item.id)
    else
      @item = Item.find(params[:id])
      render :edit
    end
  end

  private

  def item_params
    params.require(:item).permit(:genre_id, :name, :image, :introduction, :price, :is_active)
  end

end
