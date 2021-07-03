class Public::ItemsController < ApplicationController
  skip_before_action :authenticate_customer!

  def index
    @title = '商品一覧'
    @items = Item.all.order("id DESC").page(params[:page]).per(8)
  end

  def show
    @item=Item.find(params[:id])
    @cart_item = CartItem.new
  end

  def search
    key = params[:search]
    if key
      @items = Item.where(genre: key)&.order("id DESC").page(params[:page]).per(8)
      @title = "#{key}一覧"
    else
      @items = Item.all.order("id DESC").page(params[:page]).per(8)
      @title = "商品一覧"
    end

    render :index
  end
end
