class Public::HomesController < ApplicationController
  skip_before_action :authenticate_customer!

  def top
    @items = Item.limit(4).order("created_at")
  end

  def about
  end
end
