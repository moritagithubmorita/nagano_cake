class Public::CartItemsController < ApplicationController
  def index
  end

  def update
  end

  def destroy
  end

  def self.remove_all
    #ログインユーザーの全カートアイテムを削除。
    #コントローラのクラスメソッドにしたのは、モデルを管理するのはコントローラであるという方針に則るため。モデルに作っても良かった。
    current_customer.cart_items.all.destroy_all
  end

  def create
  end
end
