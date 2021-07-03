class Public::HomesController < ApplicationController
  skip_before_action :authenticate_customer!

  def top
    @items = Item.where(is_active: true).limit(4).order("created_at DESC")
  end

  def about
  end
end
